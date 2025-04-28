json.width number_with_unit(grain.width_with_unit)
json.height number_with_unit(grain.height_with_unit)
json.extract! grain, :id, :identifier, :contour, :upload_item_id

json.scale do
  json.extract! grain.scale, :id, :type, :x1, :x2, :y1, :y2, :upload_item_id if grain.scale.present?
end

json.image do
  json.extract! grain.upload_item.image, :id, :width, :height
  json.href grain.upload_item.image.url
end
