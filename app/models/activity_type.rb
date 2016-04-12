# == Schema Information
#
# Table name: activity_types
#
#  id                  :integer          not null, primary key
#  name                :text
#  count               :integer
#  probability         :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  vocabulary_size     :integer
#  terms_count         :integer
#  default_multinomial :float
#

class ActivityType < ActiveRecord::Base

  has_many :activity_type_terms, :dependent => :delete_all
  has_many :application_activity_types, :dependent => :delete_all
  ACTIVITY_TYPES = [:adult, :communication_scheduling, :social_networks, :graphic_tools, :multimedia, :news_blogs, :leisure_fun, :educational_research, :shopping, :software_development, :others, :multicategory]

  def default_probability
    1.0 / ACTIVITY_TYPES.size
  end

  # def update_prior_probabilities(sum)
  #   self.count = Label.no_test.where(self.name.to_sym => 1).count
  #   self.probability = self.count / sum.to_f
  #   self.save
  # end

  # def self.update_all_probabilities
  #   sum = ACTIVITY_TYPES.inject(0) { |sum, at| sum + Label.no_test.where(at => 1).count }
  #   ActivityType.all.each { |activity_type| activity_type.update_prior_probabilities(sum) }
  # end

  # def add_label(label)
  #   ACTIVITY_TYPES.each { |at| @categories[at].prior_probability.count += 1 if label[at] == 1 }
  # end

end
