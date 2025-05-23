# frozen_string_literal: true

class FigureViewComponent < ViewComponent::Base
  def initialize(figures:, image:, contours: false)
    super
    @figures = figures
    @image = image
    @contours = contours
  end

  def contour_path(figure, contour)
    (contour + [contour[0]]).map do |point|
      if point[0].is_a?(Array)
        point = point[0]
      end
      "#{point[0] + (figure.x1 || 0)},#{point[1] + (figure.y1 || 0)}"
    end.join(" ")
  end

  def manual_contour_path(contour)
    contour.map do |point|
      "#{point[0]},#{point[1]}"
    end.join(" ")
  end
end
