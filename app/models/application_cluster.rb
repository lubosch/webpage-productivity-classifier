# == Schema Information
#
# Table name: application_clusters
#
#  id               :integer          not null, primary key
#  application_id   :integer
#  application_type :string
#  cluster_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ApplicationCluster < ActiveRecord::Base

  belongs_to :application, polymorphic: true

  def self.create_application_clusters(clusters)
    ApplicationCluster.where(application_type: 'Application').delete_all
    clusters.each do |cluster_id, cluster|
      cluster.each do |application_id|
        app = Application.find_by_id(application_id)
        create(application: app, cluster_id: cluster_id) if app
      end
    end
  end

  def self.create_application_page_clusters(clusters)
    ApplicationCluster.where(application_type: 'ApplicationPage').delete_all
    clusters.each do |cluster_id, cluster|
      cluster.each do |application_page_id|
        app_page = ApplicationPage.find_by_id(application_page_id)
        create(application: app_page, cluster_id: cluster_id) if app_page
      end
    end
  end

  def cluster_density
    total_count = ApplicationCluster.where(application_type: self.application_type).count
    cluster_size = ApplicationCluster.where(application_type: self.application_type, cluster_id: self.cluster_id).count
    cluster_size / total_count.to_f
  end

end
