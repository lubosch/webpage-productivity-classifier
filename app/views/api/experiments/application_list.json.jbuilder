json.applications @applications.joins(:application).select(:id, :url).select('applications.name'), :id, :url, :name, :titles

