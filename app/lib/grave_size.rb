class GraveSize
  def run(figures = nil)
    Figure.transaction do
      figures ||= Figure.includes({page: :image})
      figures.each do |figure|
        dispatch_figure(figure)
      end
    end

    nil
  end

  def dispatch_figure(figure)
    if figure.contour.present?
      stats = contour_stats_only(figure)
      return if stats.nil?
      figure.assign_attributes(
        perimeter: stats[:perimeter],
        area: stats[:area],
        width: stats[:width],
        height: stats[:height]
      )

      figure.save!
    else
      handle_figure(figure)
    end
  end

  def handle_figure(figure)
    stats = grave_stats(figure, figure.upload_item.image.data)
    return if stats.nil?
    figure.assign_attributes(
      perimeter: stats[:perimeter],
      area: stats[:area],
      width: stats[:width],
      height: stats[:height],
      contour: stats[:contour].map { |x, y| [x, y] }
    )
    figure.save!
  end

  def grave_stats(figure, image)
    if figure.manual_bounding_box
      manual_stats(figure, image)
    elsif figure.contour.present?
    elsif !figure.is_a?(GrainFigure)
      contour_stats(figure, image)
    end
  end

  def manual_stats(figure, image)
    contour = figure.manual_contour
    if contour.nil? || contour.empty?
      {contour: [], perimeter: 0, area: 0, width: 0, height: 0, angle: 0}
    else
      arc = MinOpenCV.arcLength(contour)
      area = MinOpenCV.contourArea(contour)
      rect = MinOpenCV.minAreaRect(contour)
      {contour: contour, perimeter: arc, area: area, width: rect[:width], height: rect[:height], angle: rect[:angle]}
    end
  end

  def contour_stats_only(figure)
    arc = MinOpenCV.arcLength(figure.contour)
    area = MinOpenCV.contourArea(figure.contour)
    rect = MinOpenCV.minAreaRect(figure.contour)
    {perimeter: arc, area: area, width: rect[:width], height: rect[:height], angle: rect[:angle]}
  end

  def contour_stats(figure, image)
    image = MinOpenCV.extractFigure(figure, image)
    contours = MinOpenCV.findContours(image, "tree")
    contour = contours.max_by { MinOpenCV.contourArea _1 }
    if contour.nil? || contour.empty?
      {contour: [], perimeter: 0, area: 0, width: 0, height: 0, angle: 0}
    else
      arc = MinOpenCV.arcLength(contour)
      area = MinOpenCV.contourArea(contour)
      rect = MinOpenCV.minAreaRect(contour)
      {contour: contour, perimeter: arc, area: area, width: rect[:width], height: rect[:height], angle: rect[:angle]}
    end
  end
end
