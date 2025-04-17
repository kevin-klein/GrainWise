class AnalyzePublication
  def run(upload)
    sleep(2.seconds)
    MessageBus.publish("/importprogress", "Converting pdf pages to images")

    path = create_temp_file(upload.zip.download)

    images = []

    Zip::File.open(path) do |zip_file|
      zip_file.each do |entry|
        raise "File too large when extracted" if entry.size > MAX_SIZE

        entry.extract

        images << [entry.name, entry.get_input_stream.read]
      end
    end

    figures = []
    image_count = page_count(path)
    images.each_with_index do |image, index|
      MessageBus.publish("/importprogress", {
        message: "Analyzing pages",
        progress: index.to_f / (image_count - 1)
      })
      image_name, image = image
      upload_item = upload.upload_item.create!

      image_data = image.write_to_buffer(".jpg")
      upload_item.image = ::Image.create!(width: image.width, height: image.height)
      File.binwrite(upload_item.image.file_path, image_data)
      upload_item.save!

      predictions = predict_boxes(image_data)

      predictions.each do |prediction|
        x1, y1, x2, y2 = prediction["box"]
        type_name = prediction["label"]
        type_name = "skeleton_figure" if type_name == "skeleton"
        probability = prediction["score"]
        if x1.to_i == x2.to_i || y1.to_i == y2.to_i
          next
        end

        figure = upload_item.figures.create!(x1: x1, y1: y1, x2: x2, y2: y2, probability: probability, type: type_name.camelize.singularize, publication: publication)
        figures << figure
      end

      prediction = segment(image_data)
      probability = prediction["score"]
      contour = prediction["contour"]
      figure = upload_item.figures.create!(view: upload.view, identifier: image_name, probability: probability, type: "Grain", publication: publication, contour: contour)
      figures << figure
    end

    Page.transaction do
      # MessageBus.publish("/importprogress", "Analyzing Text")
      # BuildText.new.run(publication)
      MessageBus.publish("/importprogress", "Measuring Sizes")
      GraveSize.new.run(figures)
      MessageBus.publish("/importprogress", "Analyzing Scales")
      AnalyzeScales.new.run(figures)
      MessageBus.publish("/importprogress", "Done. Please proceed to Grains in the NavBar.")
    end
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

  def predict_boxes(image)
    io = StringIO.new(image)
    file = HTTP::FormData::File.new io, filename: "page.jpg"
    response = HTTP.post(ENV["ML_SERVICE_URL"], form: {
      image: file
    })

    response.parse["predictions"]
  end

  def segment(image)
    io = StringIO.new(image)
    file = HTTP::FormData::File.new io, filename: "page.jpg"
    response = HTTP.post("#{ENV["ML_SERVICE_URL"]}/segment", form: {
      image: file
    })

    response.parse["predictions"]
  end

  def page_count(path)
    PDF::Reader.open(path, &:page_count)
  end
end
