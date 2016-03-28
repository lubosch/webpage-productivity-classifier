module Classification
  class Classification

    def self.experiment
      r1 = 0
      r2 = 0
      all = 0
      ApplicationActivityType.find_each do |app_act_type|
        application = app_act_type.application
        result = application.classify_k_nearest

        r1 += 1 if (application.evaluated_classes & result[0].flatten).present?
        r2 += 1 if (application.evaluated_classes & result[0..1].flatten).present?
        all += 1

        store_result(application, result)

        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts "#{r1} #{r2} #{all} --- #{result} --- #{application.name} -- #{application.evaluated_classes}"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
        puts "#{r1} #{r2} #{all} --- #{result} --- #{application.name} -- #{application.evaluated_classes}"
        puts "***************************************************************************************"
        puts "***************************************************************************************"
      end
    end

    def self.all_app_classification
      r1 = 0
      r2 = 0
      all = 0
      Application.where('id >= 1213 ').each do |application|
        result = application.classify

        if application.evaluated_classes.present?
          r1 += 1 if (application.evaluated_classes & result[0].flatten).present?
          r2 += 1 if (application.evaluated_classes & result[0..1].flatten).present?
          all += 1

          puts "***************************************************************************************"
          puts "***************************************************************************************"
          puts "#{r1} #{r2} #{all} --- #{result} --- #{application.name} -- #{application.evaluated_classes}"
          puts "***************************************************************************************"
          puts "***************************************************************************************"
          puts "#{r1} #{r2} #{all} --- #{result} --- #{application.name} -- #{application.evaluated_classes}"
          puts "***************************************************************************************"
          puts "***************************************************************************************"
        end

        store_result(application, result)
      end
    end

    def self.all_app_page_classification
      r1 = 0
      r2 = 0
      all = 0
      ApplicationPage.find_each do |application_page|
        result = application_page.classify

        evaluated_classes = ApplicationActivityType.where(application_page: application_page).joins(:activity_type).pluck('name').map(&:to_sym).uniq

        if evaluated_classes.present?
          r1 += 1 if (evaluated_classes & result[0].flatten).present?
          r2 += 1 if (evaluated_classes & result[0..1].flatten).present?
          all += 1

          puts "***************************************************************************************"
          puts "***************************************************************************************"
          puts "#{r1} #{r2} #{all} --- #{result} --- #{application_page.url} -- #{evaluated_classes}"
          puts "***************************************************************************************"
          puts "***************************************************************************************"
          puts "#{r1} #{r2} #{all} --- #{result} --- #{application_page.url} -- #{evaluated_classes}"
          puts "***************************************************************************************"
          puts "***************************************************************************************"
        end

        store_page_result(application_page, result)
      end
    end


    def self.store_result(application, results)
      ApplicationTypeProbability.where(application: application, method: 'MNB').delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application: application, value: probability, activity_type: act_type, method: 'MNB')
      end
    end

    def self.store_page_result(application_page, results)
      ApplicationTypeProbability.where(application_id: application_page.application_id, application_page: application_page, method: 'MNB').delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application_id: application_page.application_id, application_page: application_page, value: probability, activity_type: act_type, method: 'MNB')
      end
    end


  end
end

# Classification::Classification.experiment
# Classification::Classification.all_app_classification
# Classification::Classification.all_app_page_classification