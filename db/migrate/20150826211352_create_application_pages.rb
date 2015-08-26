class CreateApplicationPages < ActiveRecord::Migration
  def change
    create_table :application_pages do |t|
      t.references :application, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
