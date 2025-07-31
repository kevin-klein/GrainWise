class TableBuilder
  include FiguresHelper

  def build(grains)
    attributes = ["Befund",	"Probennummer", "Species", "SIA #", "Length 1 (mm)", "Length 2 (mm)", "Average length", "Breadth 1 (mm)", "Breadth 2 (mm)", "Average breadth", "Thickness 1 (mm)", "Thickness 2 (mm)", "Average thickness (mm)", "Altura foto 1", "Altura foto 2", "Average thickness (photo)", "KW 1: L x B", "KW 2: L x T", "KW 1", "KW 2", "Weight (mg)", "(KW1 + KW 2)/2"]

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
          "",
          number_with_unit(dorsal_length), # length 1
          number_with_unit(ventral_length), # length 2
          number_with_unit({unit: "mm", value: average_length}),
          number_with_unit(dorsal_width), # breadth 1
          number_with_unit(ventral_width), # breadth 2
          number_with_unit({unit: "mm", value: average_breadth}), # average breadth
          number_with_unit(thickness), # thickness 1
          "", # thickness 2
          "", # average thickness
          "", # altura 1
          "", # altura 2
          "", # average altura
          "", # average thickness photo
          safe_mul(average_length, average_breadth), # L x B
          safe_mul(average_length, thickness), # L x T
          "", # KW 1
          "", # KW 2
          "", # Weight,
          "" # (KW1 + KW2) / 2
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
