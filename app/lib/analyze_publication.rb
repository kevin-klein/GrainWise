class AnalyzePublication
  def run(upload)
    sleep(2.seconds)
    MessageBus.publish("/importprogress", "Converting pdf pages to images")

    path = create_temp_file(upload.zip.download)

    images = {}
    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        next if entry.ftype == :directory

        images[clean_name(entry.name)] ||= {ventral: nil, dorsal: nil}
        images[clean_name(entry.name)][view_type(entry.name)] = entry.get_input_stream.read
      end
    end

    figures = []
    images.each do |image_name, image_data|
      # MessageBus.publish("/importprogress", {
      #   message: "Analyzing pages",
      #   progress: index.to_f / (image_count - 1)
      # })
      ventral = image_data[:ventral]
      dorsal = image_data[:dorsal]

      dorsal_figures, dorsal_grain = AnalyzeImage.new.run(upload, image_name, dorsal, :dorsal) if dorsal.present?
      ventral_figures, ventral_grain = AnalyzeImage.new.run(upload, image_name, ventral, :ventral) if ventral.present?

      figures += [ventral_figures, ventral_grain].flatten if ventral_figures.present?
      figures += [dorsal_figures, dorsal_grain].flatten if dorsal_figures.present?

      Grain.create!(
        identifier: image_name,
        site: upload.site,
        dorsal: dorsal_grain,
        ventral: ventral_grain,
        strain: upload.strain
      )
    end

    Upload.transaction do
      AssignGrainScales.new.run(figures)
      MessageBus.publish("/importprogress", "Measuring Sizes")
      GraveSize.new.run(figures)
      MessageBus.publish("/importprogress", "Analyzing Scales")
      AnalyzeScales.new.run(figures)
      MessageBus.publish("/importprogress", "Done. Please proceed to Grains in the NavBar.")
    end
  end

  def view_type(file_name)
    file_name.split("/").first.to_sym
  end

  def clean_name(file_name)
    file_name.split("/")[1..].join("").split(".")[0...-1].join("")
  end

  def create_temp_file(pdf)
    @file = Tempfile.new(SecureRandom.hex, binmode: true)
    @file.write(pdf)
    @file.flush
    @file.path
  end

  def pdf_to_images(path)
    page_count = page_count(path)
    (0..page_count - 1).lazy.map do |page|
      Vips::Image.pdfload(path, page: page, dpi: 300).flatten
    end
  end
end
