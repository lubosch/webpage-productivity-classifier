json.data @activities do |activity|
  json.id activity.id
  json.start activity.created_at.strftime('%Y-%m-%d %H:%M:%S')
  json.end (activity.created_at + activity.length.to_f).strftime('%Y-%m-%d %H:%M:%S')
  json.group activity.application_id
  json.content activity.titles
end

index = 0
json.groups @groups do |id, name, size|
  json.id id
  json.content name
  json.order index
  index+=1
end
