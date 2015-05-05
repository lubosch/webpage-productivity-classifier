class CreateCategoryDomains < ActiveRecord::Migration
  def change
    create_table :category_domains do |t|
      t.references :category, index: true, foreign_key: true
      t.references :domain, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
