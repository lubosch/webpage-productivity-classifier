Dir["#{Rails.root}/lib/experiments/*.rb"].each {|file| require_dependency file }


module Experiments

end