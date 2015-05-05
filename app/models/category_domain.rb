class CategoryDomain < ActiveRecord::Base
  belongs_to :category
  belongs_to :domain
end
