class AnalyzeImage
  def run(upload, image_name, image, view_type)
    image = Vips::Image.new_from_buffer(image, "")
    upload_item = upload.upload_items.new

    image_data = image.write_to_buffer(".jpg")
    upload_item.image = ::Image.create!(width: image.width, height: image.height)
    File.binwrite(upload_item.image.file_path, image_data)
    upload_item.save!

    predictions = predict_boxes(image_data)

    figures = []

    predictions.each do |prediction|
      x1, y1, x2, y2 = prediction["box"]
      type_name = prediction["label"]
      probability = prediction["score"]
      if x1.to_i == x2.to_i || y1.to_i == y2.to_i
        next
      end

      figure = upload_item.figures.create!(x1: x1, y1: y1, x2: x2, y2: y2, probability: probability, type: type_name.camelize.singularize, upload: upload)
      figures << figure
    end

    prediction = segment(image_data)
    probability = prediction["score"]
    contour = prediction["contour"].map do |item|
      item.flatten
    end
    grain = upload_item.figures.create!(view: view_type, identifier: image_name, probability: probability, type: "GrainFigure", upload: upload, contour: contour)

    [figures, grain]
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
end
