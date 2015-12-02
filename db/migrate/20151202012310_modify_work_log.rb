class ModifyWorkLog < ActiveRecord::Migration
  def change
    add_column :implicit_work_logs, :user_id, :integer

  end
end
