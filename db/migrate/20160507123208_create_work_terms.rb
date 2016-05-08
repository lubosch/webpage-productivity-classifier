class CreateWorkTerms < ActiveRecord::Migration
  def change
    create_table :work_terms do |t|
      t.references :activity_type, index: true
      t.integer :work_id
      t.integer :tf
      t.float :probability
      t.float :multinomial_probability
      t.string :term_type

      t.timestamps null: false
    end
  end
end
