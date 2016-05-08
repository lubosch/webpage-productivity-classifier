module Classification
  class Classification

    @queue = :classification_mnb

    def self.perform(app_id)
      application = Application.find(app_id)
      result = application.classify
      store_result_mnb(application, result)
    end

    def self.all_app_classification_mnb
      Application.find_each do |application|
        # Resque.enqueue(Classification, application.id)
        result = application.classify
        store_result_mnb(application, result)
      end
    end

    def self.all_app_page_classification_mnb
      ApplicationActivityType.test.find_each do |app_act_type|
        application_page = app_act_type.application_page
        # ApplicationPage.find_each do |application_page|
        result = application_page.classify
        store_page_result_mnb(application_page, result)
      end
    end

    def self.all_app_page_w_classification_mnb
      ApplicationActivityType.test.find_each do |app_act_type|
        application_page = app_act_type.application_page
        # ApplicationPage.find_each do |application_page|
        result = application_page.classify_w
        store_page_w_result_mnb(application_page, result)
      end
    end


    def self.store_result_mnb(application, results)
      ApplicationTypeProbability.where(application: application, method: ApplicationTypeProbability::METHODS[:mnb]).delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application: application, value: probability, activity_type: act_type, method: ApplicationTypeProbability::METHODS[:mnb])
      end
    end

    def self.store_page_result_mnb(application_page, results)
      ApplicationTypeProbability.where(application_id: application_page.application_id, application_page: application_page, method: ApplicationTypeProbability::METHODS[:mnb]).delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application_id: application_page.application_id, application_page: application_page, value: probability, activity_type: act_type, method: ApplicationTypeProbability::METHODS[:mnb])
      end
    end

    def self.store_page_w_result_mnb(application_page, results)
      WorkProbability.where(application_id: application_page.application_id, application_page: application_page, method: ApplicationTypeProbability::METHODS[:mnb]).delete_all

      results.each do |name, probability|
        work = Work.find_by_name(name)
        WorkProbability.create(application_id: application_page.application_id, application_page: application_page, value: probability, work: work, method: ApplicationTypeProbability::METHODS[:mnb])
      end
    end


    def self.all_app_classification_knn
      Application.each do |application|
        result = application.classify_knn
        store_result_knn(application, result)
      end
    end

    def self.all_app_page_classification_knn
      ApplicationActivityType.test.find_each do |app_act_type|
        application_page = app_act_type.application_page
        # ApplicationPage.where('id').find_each do |application_page|
        result = application_page.classify_knn
        store_page_result_knn(application_page, result)
        # end
      end
    end


    def self.all_app_page_w_classification_knn
      ApplicationActivityType.test.find_each do |app_act_type|
        application_page = app_act_type.application_page
        # ApplicationPage.where('id').find_each do |application_page|
        result = application_page.classify_knn
        store_page_w_result_knn(application_page, result)
        # end
      end
    end

    def self.store_result_knn(application, results)
      ApplicationTypeProbability.where(application: application, method: ApplicationTypeProbability::METHODS[:knn]).delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application: application, value: probability, activity_type: act_type, method: ApplicationTypeProbability::METHODS[:knn])
      end
    end

    def self.store_page_result_knn(application_page, results)
      ApplicationTypeProbability.where(application_id: application_page.application_id, application_page: application_page, method: ApplicationTypeProbability::METHODS[:knn]).delete_all

      results.each do |name, probability|
        act_type = ActivityType.find_by_name(name)
        ApplicationTypeProbability.create(application_id: application_page.application_id, application_page: application_page, value: probability, activity_type: act_type, method: ApplicationTypeProbability::METHODS[:knn])
      end
    end

    def self.store_page_w_result_knn(application_page, results)
      WorkProbability.where(application_id: application_page.application_id, application_page: application_page, method: ApplicationTypeProbability::METHODS[:knn]).delete_all

      results.each do |name, probability|
        work = Work.find_by_name(name)
        WorkProbability.create(application_id: application_page.application_id, application_page: application_page, value: probability, work: work, method: ApplicationTypeProbability::METHODS[:knn])
      end
    end


  end
end

# Classification::Classification.all_app_classification_mnb
# Classification::Classification.all_app_page_classification_mnb
# Classification::Classification.all_app_page_w_classification_mnb
# Classification::Classification.all_app_page_classification_knn
# Classification::Classification.all_app_page_w_classification_knn