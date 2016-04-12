module Classification
  class ClassificationExperiment

    def self.mnb
      r1 = 0
      r2 = 0
      all = 0
      ApplicationActivityType.find_each do |app_act_type|
        application = app_act_type.application
        result = application.classify_precomputed(ApplicationTypeProbability::METHODS[:mnb])

        r1 += 1 if (application.evaluated_classes & result[0...1]).present?
        r2 += 1 if (application.evaluated_classes & result[0..1]).present?
        all += 1

        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts "#{r1} #{r2} #{all} --- #{result} --- #{application.name} -- #{application.evaluated_classes}"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
      end
    end

  end
end

# Classification::ClassificationExperiment.mnb
