class AnalyzePublication
  def run(upload)
    perform_work(upload)
  rescue => e
    MessageBus.publish(
      "/importprogress",
      {error: e.message, backtrace: e.backtrace}
    )

    raise
  end

  private

  def perform_work(upload)
    sleep(2.seconds)
    MessageBus.publish("/importprogress", "Analyzing zip file contents")

    path = create_temp_file(upload.zip.download)

    images = {}

    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        next if entry.ftype == :directory
        next if entry.name.include?("__MACOSX")

        images[clean_name(entry.name)] ||= {ventral: nil, dorsal: nil, lateral: nil}
        images[clean_name(entry.name)][view_type(entry.name)] = entry.get_input_stream.read

        if ![:dorsal, :ventral, :lateral, :ts].include?(view_type(entry.name))
          raise ArgumentError.new("invalid entry #{entry.name}, view type #{view_type(entry.name)} is invalid!")
        end
      end
    end

    figures = []

    images.each do |image_name, image_data|
      ventral = image_data[:ventral]
      dorsal = image_data[:dorsal]
      lateral = image_data[:lateral]
      ts = image_data[:ts]

      dorsal_figures, dorsal_grain = AnalyzeImage.new.run(upload, image_name, dorsal, :dorsal) if dorsal.present?
      ventral_figures, ventral_grain = AnalyzeImage.new.run(upload, image_name, ventral, :ventral) if ventral.present?
      lateral_figures, lateral_grain = AnalyzeImage.new.run(upload, image_name, lateral, :lateral) if lateral.present?
      ts_figures, ts_grain = AnalyzeImage.new.run(upload, image_name, lateral, :ts) if ts.present?

      figures.concat([ventral_figures, ventral_grain].compact.flatten) if ventral.present?
      figures.concat([dorsal_figures, dorsal_grain].compact.flatten) if dorsal.present?
      figures.concat([lateral_figures, lateral_grain].compact.flatten) if lateral.present?
      figures.concat([ts_figures, ts_grain].compact.flatten) if ts.present?

      if dorsal_grain.nil? && ventral_grain.nil? && lateral_grain.nil?
        raise ArgumentError.new("No views for grain #{image_name} were found.")
      end

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

  def view_type(file_name)
    file_name.split("/")[-2].downcase.to_sym
  end

  def clean_name(file_name)
    file_name.split("/")[-1].split(".")[0...-1].join("")
  end

  def create_temp_file(data)
    path = "#{Rails.root}/tmp/#{SecureRandom.hex}.zip"
    File.binwrite(path, data)
    path
  end
end
