json.data @activities do |activity|
  json.id activity.id
  json.start activity.created_at.strftime('%Y-%m-%d %H:%M:%S')
  json.end (activity.created_at + activity.length.to_f).strftime('%Y-%m-%d %H:%M:%S')
  json.group activity.application_id
  json.content (@activity_terms[activity.application_page_id] || activity.titles)
  json.className 'unclassified'
end

index = 0
json.groups @groups do |id, name, count, length|
  json.id id
  json.content "#{name} (#{length} sec)"
  json.order index
  json.length length
  json.count count
  index+=1
end
