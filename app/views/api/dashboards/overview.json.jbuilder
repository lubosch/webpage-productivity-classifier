json.data @activities do |activity|
  json.id activity.id
  json.startAt activity.created_at.strftime('%Y-%m-%d %H:%M:%S')
  json.endAt (activity.created_at + activity.length.to_f).strftime('%Y-%m-%d %H:%M:%S')
  json.applicationId activity.application_id
  json.name (@activity_terms[activity.application_page_id] || activity.titles || '-')
end

index = 0
json.groups @groups do |id, name, count, length|
  json.id id
  json.name name
  json.index index
  json.duration length
  json.count count
  index+=1
end
