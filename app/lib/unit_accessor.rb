module UnitAccessor
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def with_unit(name, square: false)
      define_method(:"#{name}_with_unit") do
        if scale.present? && scale.milli_meter_ratio&.positive?
          ratio = scale.milli_meter_ratio
          ratio = scale.milli_meter_ratio**2 if square
          return {value: 0, unit: "px"} if send(name).nil?
          return {value: send(name), unit: "px"} if ratio.nil?
          {value: send(name) * ratio, unit: value_unit(square)}
        else
          {value: send(name), unit: "px"}
        end
      end
    end
  end

  def value_unit(square)
    if square
      "mm&sup2;"
    else
      "mm"
    end
  end
end
