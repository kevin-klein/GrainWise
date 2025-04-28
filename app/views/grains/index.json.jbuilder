json.array! @grains do |grain|
  json.partial! "grains/grain", locals: {grain: grain}
end
