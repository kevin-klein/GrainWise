# app/services/analyze_publication.rb
class AnalyzePublication
  # --------------------------------------------------------------------
  # Public: Entry point called by a background job
  # --------------------------------------------------------------------
  def run(upload)
    # Keep the original behaviour – only add a wrapper

    perform_work(upload)
  rescue => e
    # 1️⃣  Notify the user
    MessageBus.publish(
      "/importprogress",
      {error: e.message, backtrace: e.backtrace}
    )

    # 2️⃣  Re‑raise so Sidekiq (or whatever) can retry / log it
    raise
  end

  private

  # --------------------------------------------------------------------
  # Core logic – exactly what you already had
  # --------------------------------------------------------------------
  def perform_work(upload)
    sleep(2.seconds)
    MessageBus.publish("/importprogress", "Analyzing zip file contents")

    path = create_temp_file(upload.zip.download)

    images = {}

    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        next if entry.ftype == :directory

        images[clean_name(entry.name)] ||= {ventral: nil, dorsal: nil, lateral: nil}
        images[clean_name(entry.name)][view_type(entry.name)] = entry.get_input_stream.read
      end
    end

    figures = []

    images.each do |image_name, image_data|
      ventral = image_data[:ventral]
      dorsal = image_data[:dorsal]
      lateral = image_data[:lateral]
      ts = image_data[:ts]

      # ------------------------------------------------------------------
      # All image analyses – guard with `present?`
      # ------------------------------------------------------------------
      dorsal_figures, dorsal_grain = AnalyzeImage.new.run(upload, image_name, dorsal, :dorsal) if dorsal.present?
      ventral_figures, ventral_grain = AnalyzeImage.new.run(upload, image_name, ventral, :ventral) if ventral.present?
      lateral_figures, lateral_grain = AnalyzeImage.new.run(upload, image_name, lateral, :lateral) if lateral.present?
      ts_figures, ts_grain = AnalyzeImage.new.run(upload, image_name, lateral, :ts) if ts.present?

      figures.concat([ventral_figures, ventral_grain].compact.flatten) if ventral_figures.present?
      figures.concat([dorsal_figures, dorsal_grain].compact.flatten) if dorsal_figures.present?
      figures.concat([lateral_figures, lateral_grain].compact.flatten) if lateral_figures.present?
      figures.concat([ts_figures, ts_grain].compact.flatten) if ts_figures.present?

      Grain.create!(
        identifier: image_name,
        site: upload.site,
        dorsal: dorsal_grain,
        lateral: lateral_grain,
        ventral: ventral_grain,
        strain: upload.strain,
        upload: upload
      )
    end

    # --------------------------------------------------------------------
    # Final calculations wrapped in a single transaction
    # --------------------------------------------------------------------
    Upload.transaction do
      upload.reload
      AssignGrainScales.new.run(upload.figures)
      MessageBus.publish("/importprogress", "Measuring Sizes")
      GraveSize.new.run(upload.figures)
      MessageBus.publish("/importprogress", "Analyzing Scales")
      AnalyzeScales.new.run(upload.figures)
      MessageBus.publish("/importprogress", "Done. Please proceed to Grains in the NavBar.")
    end
  end

  # --------------------------------------------------------------------
  # Helpers – unchanged
  # --------------------------------------------------------------------
  def view_type(file_name)
    file_name.split("/").first.to_sym
  end

  def clean_name(file_name)
    file_name.split("/")[1..].join("").split(".")[0...-1].join("")
  end

  def create_temp_file(data)
    # file = File.new(SecureRandom.hex, binmode: true)
    # file.write(pdf)
    # file.flush
    # file.path

    path = "#{Rails.root}/tmp/#{SecureRandom.hex}.zip"
    File.binwrite(path, data)
    path
  end
end
