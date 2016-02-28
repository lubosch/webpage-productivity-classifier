class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name
      t.references :application, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
