class CreateCategoryTerms < ActiveRecord::Migration
  def change
    create_table :category_terms do |t|
      t.references :category, index: true, foreign_key: true
      t.references :term, index: true, foreign_key: true
      t.integer :count
      t.float :probability

      t.timestamps null: false
    end
  end
end
