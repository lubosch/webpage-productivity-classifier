class CreateApplicationClusters < ActiveRecord::Migration
  def change
    create_table :application_clusters do |t|
      t.belongs_to :application, :polymorphic => true
      t.integer :cluster_id

      t.timestamps null: false
    end
    add_index :application_clusters, [:application_id, :application_type], name: :application_clusters_polymoprh_application_index

  end
end
