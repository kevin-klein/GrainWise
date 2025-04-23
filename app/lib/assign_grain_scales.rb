class AssignGrainScales
  def run(figures = nil)
    Figure.transaction do
      figures ||= Figure.includes({page: :image})
      figures.each do |figure|
        dispatch_figure(figure) if figure.is_a?(Grain)
      end
    end

    nil
  end

  def dispatch_figure(figure)
    figure.scale = figure.upload_item.figures.where(type: 'Scale').first
    figure.save!
  end
end
