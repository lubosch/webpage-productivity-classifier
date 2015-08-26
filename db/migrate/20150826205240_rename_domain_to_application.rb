class RenameDomainToApplication < ActiveRecord::Migration
  def change
    rename_table :domains, :applications
  end
end
