class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :name
      t.integer :count
      t.float :probability
      t.integer :vocabulary_size
      t.integer :terms_count
      t.float :default_multinomial

      t.timestamps null: false
    end
  end
end
