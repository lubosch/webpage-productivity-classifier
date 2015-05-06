class AddProbabilityToTerm < ActiveRecord::Migration
  def change
    add_column :terms, :probability, :decimal
  end
end
