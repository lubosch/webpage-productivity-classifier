class CreateImplicitWorkLogs < ActiveRecord::Migration
  def change
    create_table :implicit_work_logs do |t|
      t.string :ip
      t.integer :in_work

      t.timestamps null: false
    end
  end
end
