class AddMultinomialProbability < ActiveRecord::Migration
  def change
    add_column :category_terms, :multinomial_probability, :float
    add_column :categories, :vocabulary_size, :integer
    add_column :categories, :terms_count, :integer
    add_column :categories, :default_multinomial, :float
  end
end
