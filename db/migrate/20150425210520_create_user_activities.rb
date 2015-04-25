class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|

      t.timestamps null: false
    end
  end
end
