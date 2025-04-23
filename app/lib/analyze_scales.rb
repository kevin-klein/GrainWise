class AnalyzeScales
  def analyze_scale(scale)
    return unless scale.is_a?(Scale)
    # (1.0..2.0).step(0.25).each do |factor|
    assign_contour_width(scale)
    # break if scale.width.nil? || scale.width > 0
    # end

    text = scale_text(scale)
    distance, ratio = calculate_contour_ratio(scale, text)

    return if distance.nil?

    scale.milli_meter_ratio = ratio
    scale.text = distance * 100
    ap scale
    scale.save!
  end

  def scale_text(scale)
    scale.y1 -= 30
    scale.y2 += 30
    image = MinOpenCV.extractFigure(scale, scale.upload_item.image.data)
    return "" if image.size == 0

    scale.y1 += 30
    scale.y2 -= 30

    begin
      MinOpenCV.imwrite("scale.jpg", image)
      t = RTesseract.new("scale.jpg", lang: "eng")
      result = t.to_s.strip
      result.tr("i", "1").tr("I", "1")
    rescue
    end
  end

  def calculate_contour_ratio(scale, text)
    if text.empty?
      distance = 1.0 # assume default 1mm
    else
      cm_match = text.match(/([0-9]+)cm$/)
      mm_match = text.match(/([0-9]+)mm$/)
      distance = if cm_match
        cm_match.captures[0].to_f * 10
      elsif mm_match
        mm_match.captures[0].to_f
      end
    end

    ratio = if distance.present?
      distance / scale.width
    end

    [distance, ratio]
  end

  def assign_contour_width(scale)
    image = MinOpenCV.extractFigure(scale, scale.upload_item.image.data)
    contours = MinOpenCV.findContours(image, "tree")
    rects = contours.map { MinOpenCV.minAreaRect _1 }

    return if rects.empty?

    max_rect = rects.max_by { [_1[:width], _1[:height]].max }
    width = [max_rect[:width], max_rect[:height]].max

    scale.width = width
    scale.save!
  end

  def run(scales = nil)
    scales ||= Scale.all
    Scale.transaction do
      scales.each do |scale|
        analyze_scale(scale)
      end
    end

    nil
  end
end
