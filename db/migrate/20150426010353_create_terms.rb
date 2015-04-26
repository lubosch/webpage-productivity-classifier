class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.integer :eval_id
      t.string :text
      t.integer :tf
      t.integer :df

      t.timestamps null: false
    end
  end
end
