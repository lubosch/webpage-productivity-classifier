class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.string :eval_type
      t.references :domain, index: true, foreign_key: true
      t.integer :alter_id
      t.integer :eval_id

      t.timestamps null: false
    end
  end
end
