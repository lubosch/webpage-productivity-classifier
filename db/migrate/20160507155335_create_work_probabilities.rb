class CreateWorkProbabilities < ActiveRecord::Migration
  def change
    create_table :work_probabilities do |t|
      t.references :application, index: true, foreign_key: true
      t.references :work, index: true, foreign_key: true
      t.string :method
      t.float :value
      t.references :application_page, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
