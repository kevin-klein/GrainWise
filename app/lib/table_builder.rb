class TableBuilder
  include FiguresHelper

  def build(grains)
    attributes = ["Befund",	"Sample", "Species", "Length 1 (mm)", "Length 2 (mm)", "Average length", "Breadth 1 (mm)", "Breadth 2 (mm)", "Average breadth", "Thickness (mm)"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      grains.each do |grain|
        dorsal_length = grain.dorsal&.height_with_unit
        ventral_length = grain.ventral&.height_with_unit

        average_length = if ventral_length.nil?
          dorsal_length&.dig(:value)
        elsif dorsal_length.nil?
          ventral_length&.dig(:value)
        else
          (dorsal_length[:value] + ventral_length[:value]) / 2
        end

        dorsal_width = grain.dorsal&.width_with_unit
        ventral_width = grain.ventral&.width_with_unit

        average_breadth = if ventral_width.nil?
          dorsal_width&.dig(:value)
        elsif dorsal_length.nil?
          ventral_width&.dig(:value)
        else
          (dorsal_width[:value] + ventral_width[:value]) / 2
        end

        thickness = grain.lateral&.width_with_unit

        csv << [
          grain.upload.feature,
          grain.identifier,
          grain.strain.name,
          number_with_unit(dorsal_length), # length 1
          number_with_unit(ventral_length), # length 2
          number_with_unit({unit: "mm", value: average_length}),
          number_with_unit(dorsal_width), # breadth 1
          number_with_unit(ventral_width), # breadth 2
          number_with_unit({unit: "mm", value: average_breadth}), # average breadth
          number_with_unit(thickness), # thickness
        ]
      end
    end
  end

  def safe_mul(x, y)
    if x.nil? || y.nil?
      nil
    else
      x * y
    end
  end
end
