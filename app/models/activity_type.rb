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

  def update_probabilities
    terms_count = activity_type_terms.sum(:tf)
    vocabulary_size = activity_type_terms.count
    update(:terms_count => terms_count, :vocabulary_size => vocabulary_size, :default_multinomial => 1/(vocabulary_size + terms_count))
    activity_type_terms.update_all("probability = tf / #{terms_count.to_f}, multinomial_probability = (count+1) / #{terms_count + vocabulary_size.to_f}")
  end

  def add_terms(application)
    @ct ||= {}
    application.application_terms.includes(:term).each do |dt|
      if dt.term
        @ct[dt.term.id] ||= ActivityTypeTerm.new(:category => self, :term => dt.term, :count => 0)
        @ct[dt.term.id].count += dt.tf
      end
    end
  end

  def save_terms
    @ct.each_value(&:save) if @ct
  end

  def update_prior_probabilities(sum)
    self.count = Label.no_test.where(self.name.to_sym => 1).count
    self.probability = self.count / sum.to_f
    self.save
  end

  def self.update_all_probabilities
    sum = ACTIVITY_TYPES.inject(0) { |sum, at| sum + Label.no_test.where(at => 1).count }
    ActivityType.all.each { |activity_type| activity_type.update_prior_probabilities(sum) }
  end

  def add_label(label)
    ACTIVITY_TYPES.each { |at| @categories[at].prior_probability.count += 1 if label[at] == 1 }
  end

end
