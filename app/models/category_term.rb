class CategoryTerm < ActiveRecord::Base
  belongs_to :category
  belongs_to :term
end
