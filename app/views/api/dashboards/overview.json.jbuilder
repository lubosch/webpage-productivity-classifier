json.data @activities do |activity|
  json.id activity.id
  json.start activity.created_at.in_time_zone.strftime('%Y-%m-%d %H:%M:%S')
  json.end (activity.created_at.in_time_zone + activity.length.to_f).strftime('%Y-%m-%d %H:%M:%S')
  json.group activity.application_id
  json.content activity.url
end

json.groups @groups do |group|
  json.id group[0]
  # json.start group.created_at.strftime('%Y-%m-%d %H:%M:%S')
  # json.end (group.created_at + group.length).strftime('%Y-%m-%d %H:%M:%S')
  # json.group group.application_page_id
  json.content group[1]
end
