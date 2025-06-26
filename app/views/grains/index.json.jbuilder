json.grains @grains do |grain|
  json.partial! "grains/grain", locals: {grain: grain}
end
json.pagination @pagination
