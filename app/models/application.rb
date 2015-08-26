# == Schema Information
#
# Table name: applications
#
#  id         :integer          not null, primary key
#  name       :string
#  eval_type  :string
#  lang       :string
#  eval_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Application < ActiveRecord::Base
  has_many :application_terms, primary_key: :eval_id, foreign_key: :application_page_id
  has_many :labels, primary_key: :eval_id

  scope :no_test, -> { where(:eval_type => nil) }
  scope :test, -> { where(:eval_type => 'test') }

  def classify
    activity_type_probabilities = {}
    ActivityType.all.each { |activity_type| activity_type_probabilities[activity_type.name.to_sym] = activity_type_probability(activity_type) }
    activity_type_probabilities.sort_by { |_c, v| v }.reverse
  end

  def classify_k_nearest
    category_probabilities = neo_host.classify(0, 1)
    category_probabilities.blank? ? classify : category_probabilities.sort_by { |_c, v| v }.reverse
  end

  def neo_host
    Neo::Host.find_by(:eval_id => eval_id)
  end

  def activity_type_probability(category)
    likelihood = 0
    application_terms.includes(:term => :activity_type_terms).each do |dt|
      likelihood += dt.generating_multinomial_likelihood(category)
      # likelihood += dt.generating_bernouolli_likelihood(category)
    end
    likelihood + Math.log2(category.probability)
  end

  def self.experiment
    mrr=0
    r1 = 0
    r2 = 0
    all = 0
    Application.test.each do |application|
      eval = 1
      result = application.classify_k_nearest
      # result[0..1].each_with_index do |(name, _val), i|
      #   if application.labels.find { |label| label[name.to_sym] == 1 }
      #     mrr += eval / (i+1).to_f
      #     eval += 1
      #   end
      # end
      # all += application.evaluated_classes.size

      r1 += 1 if (application.evaluated_classes & result[0].flatten).present?
      r2 += 1 if (application.evaluated_classes & result[0..1].flatten).present?
      all += 1

      puts "***************************************************************************************"
      puts "***************************************************************************************"
      puts "#{r1} #{r2} #{all} --- #{result} --- #{application.labels.inspect}"
      puts "***************************************************************************************"
      puts "***************************************************************************************"
      puts "#{r1} #{r2} #{all} --- #{result} --- #{application.labels.inspect}"
      puts "***************************************************************************************"
      puts "***************************************************************************************"
    end
  end

  def evaluated_classes
    labels.map { |label| label.categories }.flatten.uniq
  end

end
