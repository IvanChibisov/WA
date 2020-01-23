json.results @search.results do |price_list|
  json.label price_list.name
  json.value price_list.id
end
