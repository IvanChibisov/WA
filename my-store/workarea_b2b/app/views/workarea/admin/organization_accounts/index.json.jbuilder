json.results @search.results do |account|
  json.label "#{account.organization.name} / #{account.name}"
  json.value account.id
end
