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



  desc 'KNN classification'
  task :precomputing_knn => :environment do
    Clustering::NeoPrecomputation.link_probabilities
  end

  desc 'KNN classification'
  task :knn => :environment do
    Classification::Classification.all_app_page_classification_knn
  end

end
