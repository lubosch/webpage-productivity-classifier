require 'csv'

namespace :classification do
  desc 'Migrate hostname'
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
end
