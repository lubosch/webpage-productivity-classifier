# == Schema Information
#
# Table name: category_terms
#
#  id          :integer          not null, primary key
#  category_id :integer
#  term_id     :integer
#  count       :integer
#  probability :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CategoryTerm < ActiveRecord::Base
  belongs_to :category
  belongs_to :term


  def recalculate_probability(sum)
    update_attribute(:probability, self.count / sum.to_f)
  end

end
