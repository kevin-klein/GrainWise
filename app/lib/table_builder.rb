class TableBuilder
  include FiguresHelper

  def build(grains)
    attributes = ["Befund",	"Probennummer", "Species", "SIA #", "Length 1 (mm)", "Length 2 (mm)", "Average length", "Breadth 1 (mm)", "Breadth 2 (mm)", "Average breadth", "Thickness 1 (mm)", "Thickness 2 (mm)", "Average thickness (mm)", "Altura foto 1", "Altura foto 2", "Average thickness (photo)", "KW 1: L x B", "KW 2: L x T", "KW 1", "KW 2", "Weight (mg)", "(KW1 + KW 2)/2"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      grains.each do |grain|
        dorsal_length = grain.dorsal.width_with_unit
        lateral_length = grain.lateral.width_with_unit

        average_length = (dorsal_length[:value] + lateral_length[:value]) / 2

        dorsal_breadth = grain.dorsal.height_with_unit
        lateral_breadth = grain.lateral.height_with_unit

        average_breadth = (dorsal_length[:value] + lateral_length[:value]) / 2


        csv << [
          grain.upload.feature,
          grain.upload.sample,
          grain.strain.name,
          "",
          number_with_unit(dorsal_length),
          number_with_unit(lateral_length),
          number_with_unit({unit: "mm", value: average_length}),
          number_with_unit(dorsal_breadth), # breadth 1
          number_with_unit(lateral_breadth), # breadth 2
          number_with_unit({unit: "mm", value: average_breadth}), # average breadth
          number_with_unit(dorsal_breadth), # thickness 1
          number_with_unit(lateral_breadth), # thickness 2
          number_with_unit({unit: "mm", value: average_breadth}), # average thickness
          number_with_unit(dorsal_breadth), # altura 1
          number_with_unit(lateral_breadth), # altura 2
          number_with_unit({unit: "mm", value: average_breadth}), # average altura
          "", # average thickness photo
          ""
        ]
      end
    end
  end
end
