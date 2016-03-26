Dir["#{Rails.root}/lib/classification/*.rb"].each {|file| require_dependency file }


module Classification

end