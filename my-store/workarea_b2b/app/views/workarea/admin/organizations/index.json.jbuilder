json.results @search.results do |organization|
  json.label organization.name
  json.value organization.id
end
