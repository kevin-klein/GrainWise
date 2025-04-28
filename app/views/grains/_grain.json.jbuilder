json.extract! grain, :id, :identifier

if grain.ventral.present?
  json.ventral do
    json.partial! "grains/grain_figure", locals: {grain: grain.ventral}
  end
end

if grain.dorsal.present?
  json.dorsal do
    json.partial! "grains/grain_figure", locals: {grain: grain.dorsal}
  end
end
