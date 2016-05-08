module Classification
  class ClassificationExperiment

    def self.mnb
      r1 = 0
      r2 = 0
      all = 0
      ApplicationActivityType.test.find_each do |app_act_type|
        # application = app_act_type.application
        application = app_act_type.application_page
        result = application.classify_precomputed(ApplicationTypeProbability::METHODS[:mnb])

        r1 += 1 if (application.evaluated_classes & result[0...1]).present?
        r2 += 1 if (application.evaluated_classes & result[0..1]).present?
        all += 1

        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts "#{r1} #{r2} #{all} --- #{result} --- #{application.url} -- #{application.evaluated_classes}"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
      end
    end

    def self.knn
      success_r1 = {}
      success_r2 = {}
      error_r1 = {}
      error_r2 = {}

      r1 = 0
      r2 = 0
      all = 0
      ApplicationActivityType.test.find_each do |app_act_type|
        application_page = app_act_type.application_page
        # result = application_page.classify_precomputed(ApplicationTypeProbability::METHODS[:knn])
        result = application_page.classify_precomputed(ApplicationTypeProbability::METHODS[:mnb])
        # result = application_page.classify_precomputed_cumm.sort_by { |_c, v| v.nan? ? 0 : v }.reverse.map(&:first).map(&:to_sym)
        # puts result
        # result = result.sort_by { |_c, v| v.nan? ? 0 : v }.reverse.map(&:first).map(&:to_sym)
        # binding.pry

        # result = application_page.classify_knn.sort_by { |_c, v| v }.reverse.map(&:first)
        if (application_page.evaluated_classes & result[0...1]).present?
          success_r1[result[0]] ||= 0
          success_r1[result[0]] += 1
          r1 += 1
        else
          application_page.evaluated_classes.each do |klass|
            error_r1[klass] ||= 0
            error_r1[klass] += 1
          end
        end
        if (application_page.evaluated_classes & result[0..1]).present?
          r2 += 1
        end
        all += 1

        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts " #{r1} #{r2} #{all} --- success: #{success_r1} || error: #{error_r1} || diff: #{success_r1.map { |k, v| [k, v - (error_r1[k] || 0)] }.sort_by(&:last)}  --- #{r1} #{r2} #{all} --- #{result} --- #{application_page.url} -- #{application_page.evaluated_classes}"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
        # binding.pry
      end
    end


    def self.work
      success_r1 = {}
      success_r2 = {}
      error_r1 = {}
      error_r2 = {}

      r1 = 0
      r2 = 0
      all = 0
      ApplicationActivityType.where.not(work_id: nil).test.find_each do |app_act_type|
        application_page = app_act_type.application_page
        # result = application_page.classify_w_precomputed(ApplicationTypeProbability::METHODS[:knn])
        # result = application_page.classify_w_precomputed(ApplicationTypeProbability::METHODS[:mnb])
        result = application_page.classify_w_precomputed_cumm.sort_by { |_c, v| v}.reverse.map(&:first).map(&:to_sym)
        # puts result
        # result = result.sort_by { |_c, v| v.nan? ? 0 : v }.reverse.map(&:first).map(&:to_sym)
        # binding.pry

        # result = application_page.classify_knn.sort_by { |_c, v| v }.reverse.map(&:first)
        if (application_page.evaluated_classes_w & result[0...1]).present?
          success_r1[result[0]] ||= 0
          success_r1[result[0]] += 1
          r1 += 1
        else
          application_page.evaluated_classes_w.each do |klass|
            error_r1[klass] ||= 0
            error_r1[klass] += 1
          end
        end
        if (application_page.evaluated_classes_w & result[0..1]).present?
          r2 += 1
        end
        all += 1

        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts " #{r1} #{r2} #{all} --- success: #{success_r1} || error: #{error_r1} || diff: #{success_r1.map { |k, v| [k, v - (error_r1[k] || 0)] }.sort_by(&:last)}  --- #{r1} #{r2} #{all} --- #{result} --- #{application_page.url} -- #{application_page.evaluated_classes_w}"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
        # binding.pry
      end
    end

  end
end

# Classification::ClassificationExperiment.mnb
# Classification::ClassificationExperiment.knn
# Classification::ClassificationExperiment.work
