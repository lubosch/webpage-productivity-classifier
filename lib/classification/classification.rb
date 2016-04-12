module Classification
  class Classification

    def self.all_app_classification_mnb
      r1 = 0
      r2 = 0
      Application.find_each do |application|
        result = application.classify

        if application.evaluated_classes.present?
          r1 += 1 if (application.evaluated_classes & result[0].flatten).present?
          r2 += 1 if (application.evaluated_classes & result[0..1].flatten).present?
        end

        store_result_mnb(application, result)
      end
    end

    def self.all_app_page_classification_mnb
      r1 = 0
      r2 = 0
      ApplicationPage.find_each do |application_page|
        result = application_page.classify

        evaluated_classes = ApplicationActivityType.where(application_page: application_page).joins(:activity_type).pluck('name').map(&:to_sym).uniq

        if evaluated_classes.present?
          r1 += 1 if (evaluated_classes & result[0].flatten).present?
          r2 += 1 if (evaluated_classes & result[0..1].flatten).present?
        end

        store_page_result_mnb(application_page, result)
      end
    end


    def self.store_result_mnb(application, results)
      ApplicationTypeProbability.where(application: application, method: ApplicationTypeProbability::METHODS[:mnb3]).delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application: application, value: probability, activity_type: act_type, method: ApplicationTypeProbability::METHODS[:mnb3])
      end
    end

    def self.store_page_result_mnb(application_page, results)
      ApplicationTypeProbability.where(application_id: application_page.application_id, application_page: application_page, method: ApplicationTypeProbability::METHODS[:mnb3]).delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application_id: application_page.application_id, application_page: application_page, value: probability, activity_type: act_type, method: ApplicationTypeProbability::METHODS[:mnb3])
      end
    end

    def self.all_app_classification_knn
      r1 = 0
      r2 = 0

      Application.each do |application|
        result = application.classify_knn

        if application.evaluated_classes.present?
          r1 += 1 if (application.evaluated_classes & result[0].flatten).present?
          r2 += 1 if (application.evaluated_classes & result[0..1].flatten).present?
        end

        store_result_knn(application, result)
      end
    end

    def self.all_app_page_classification_knn
      r1 = 0
      r2 = 0
      ApplicationPage.each do |application_page|
        result = application_page.classify_knn

        evaluated_classes = application_page.evaluated_classes

        if evaluated_classes.present?
          r1 += 1 if (evaluated_classes & result[0].flatten).present? if result[0].present?
          r2 += 1 if (evaluated_classes & result[0..1].flatten).present? if result[1].present?
        end

        store_page_result_knn(application_page, result)
      end
    end


    def self.store_result_knn(application, results)
      ApplicationTypeProbability.where(application: application, method: 'KNN').delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application: application, value: probability, activity_type: act_type, method: 'KNN')
      end
    end

    def self.store_page_result_knn(application_page, results)
      ApplicationTypeProbability.where(application_id: application_page.application_id, application_page: application_page, method: 'KNN').delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application_id: application_page.application_id, application_page: application_page, value: probability, activity_type: act_type, method: 'KNN')
      end
    end


  end
end

# Classification::Classification.experiment
# Classification::Classification.all_app_classification_mnb
# Classification::Classification.all_app_page_classification