class CreateApplicationTypeProbabilities < ActiveRecord::Migration
  def change
    create_table :application_type_probabilities do |t|
      t.references :application, index: true, foreign_key: true
      t.references :activity_type, index: true, foreign_key: true
      t.string :method
      t.float :value
      t.references :application_page, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
