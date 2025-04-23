json.array! @grains do |grain|
  json.extract! grain, :id, :identifier, :contour
  json.scale do
    json.extract! grain.scale, :id, :type, :x1, :x2, :y1, :y2
  end
  json.image do
    json.extract! grain.upload_item.image, :id, :width, :height
    json.href grain.upload_item.image.url
  end
end
