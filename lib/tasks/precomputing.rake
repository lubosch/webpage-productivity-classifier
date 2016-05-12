require 'csv'

namespace :classification do
  desc 'Precompute mnb classifier'
  task :precomputation => :environment do

    puts 'Classification::Precomputation.update_terms_probability'
    Classification::Precomputation.update_terms_probability
    puts 'Classification::Precomputation.update_multinomial_probability'
    Classification::Precomputation.update_multinomial_probability
    puts 'Classification::Classification.all_app_classification_mnb'
    Classification::Classification.all_app_classification_mnb

    puts 'Clustering::Clustering.cluster_applications'
    Clustering::Clustering.cluster_applications
  end


  desc 'KNN precomputing'
  task :precomputing_knn => :environment do
    Clustering::NeoPrecomputation.link_probabilities
  end

  desc 'MNB classification app pages'
  task :mnb_app_pages => :environment do
    Classification::Classification.all_app_page_classification_mnb
  end

  desc 'KNN classification'
  task :knn => :environment do
    Classification::Classification.all_app_page_classification_knn
  end


  desc 'Divide test train group'
  task :split_train => :environment do
    r = Random.new

    # ApplicationActivityType.joins(:application).where('work_id IS NOT NULL').pluck(:application_id).uniq.each { |app_id| r.rand < 0.1 ? Application.find(app_id).update(eval_type: 'test') : Application.find(app_id).update(eval_type: 'experiment') }
    # ApplicationActivityType.joins(:application).where('work_id IS NULL').pluck(:application_id).uniq.each { |app_id| r.rand < 0.19 ? Application.find(app_id).update(eval_type: 'test') : Application.find(app_id).update(eval_type: 'experiment') }

    # ApplicationActivityType.joins(:application).where('application_activity_types.created_at >= ?', '13.4.2016'.to_date).pluck(:application_id).uniq.each { |app_id| Application.find(app_id).update(eval_type: 'test') }
    ApplicationActivityType
        .joins(:application)
        .where('application_activity_types.created_at < ? AND app_type = ?', '13.4.2016'.to_date, 'web')
        .pluck(:application_id)
        .uniq.each { |app_id| Application.find(app_id).update(eval_type: (r.rand < 0.53) ? 'test' : 'experiment') }


  end

  desc 'Update multinomials after dividing'
  task :update_multinomials => :environment do
    puts 'Classification::Precomputation.refresh_activity_type_terms'
    # Classification::Precomputation.refresh_activity_type_terms
    puts 'Classification::Precomputation.update_multinomial_probability'
    Classification::Precomputation.update_multinomial_probability
    puts 'Classification::Classification.all_app_page_classification_mnb'
    Classification::Classification.all_app_page_classification_mnb
    puts 'Classification::Classification.all_app_page_classification_knn'
    # Classification::Classification.all_app_page_classification_knn
  end

  desc 'Update work multinomials after dividing'
  task :update_work_multinomials => :environment do
    Classification::Precomputation.refresh_work_terms
    Classification::Precomputation.update_work_multinomial_probability
    Classification::Classification.all_app_page_w_classification_mnb

  end


end
