module FiguresHelper
  def number_with_unit(n)
    return "" if n.nil? || n[:value].nil?

    "#{"%.2f" % n[:value]} #{n[:unit]}"
  end

  def number_without_unit(n)
    return "" if n.nil? || n[:value].nil?

    "#{"%.2f" % n[:value]}"
  end
end
