module ActiveLearning

  class AppSelection

    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def all_apps_id
      @user.application_pages.group(:application_id).pluck('application_id')
    end

    def classified_apps_id
      @user.application_activity_types.pluck(:application_id)
    end

    def unclassified_apps_id
      @user.application_pages.where.not(application_id: classified_apps_id).group(:application_id).pluck('application_id')
    end

    def unclassified_apps_occurrence
      occurrences = Hash[@user.application_pages.where.not(application_id: classified_apps_id).group(:application_id).pluck('application_id, count(application_id)')]
      max = occurrences.map { |_k, occurrence| occurrence }.max
      occurrences.each { |app_id, occ| occurrences[app_id] = occ/max.to_f }
      occurrences
    end

    def app_clusters_size
      Hash[ApplicationCluster.where(application_type: 'Application', application_id: all_apps_id).group(:cluster_id).pluck('cluster_id, count(cluster_id)')]
    end

    def self.all_clusters_size
      Hash[ApplicationCluster.where(application_type: 'Application').group(:cluster_id).having('count(cluster_id) > 1').pluck('cluster_id, count(cluster_id)')]
    end

    def clusters_ratio
      clusters_ratio = {}
      all_cluster_size = AppSelection.all_clusters_size
      app_cluster_size = app_clusters_size
      all_cluster_size.each { |cluster_id, cluster_size| clusters_ratio[cluster_id] = ((app_cluster_size[cluster_id] || 0) + 1)/cluster_size.to_f }
      clusters_ratio
    end

    def unclassified_apps_cluster_size
      clusters = {}
      ratios = clusters_ratio
      ApplicationCluster.where(application_type: 'Application', application_id: unclassified_apps_id).each { |app_cluster| clusters[app_cluster.application_id] = ratios[app_cluster.cluster_id] if ratios[app_cluster.cluster_id] }
      clusters
    end

    def apps_probabilities
      groups = {}
      probabilities = {}
      apptype_probabilities = ApplicationTypeProbability.where(application: unclassified_apps_id, application_page_id: nil, method: ApplicationTypeProbability::METHODS[:mnb])
      apptype_probabilities.each do |probability|
        groups[probability.application_id] ||= []
        groups[probability.application_id] << probability
      end

      groups.each do |app_id, app_probabilities|
        prob = app_probabilities.map { |prob| prob.value }.sum { |prob| prob == 0 ? 0 : prob*Math.log10(prob) }
        probabilities[app_id] = prob
      end

      probabilities
    end

    def best_apps
      probabilities = apps_probabilities
      clusters_ratios = unclassified_apps_cluster_size
      occurrences = unclassified_apps_occurrence
      results = {}
      unclassified_apps_id.each do |app_id|
        results[app_id] = (0 - probabilities[app_id].to_f*clusters_ratios[app_id].to_f) * occurrences[app_id].to_f
      end
      results.sort_by {|_app_id, value| value}.reverse
    end

  end

end
# ActiveLearning::AppSelection.new(User.find(2))