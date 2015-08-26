# == Schema Information
#
# Table name: domains
#
#  id         :integer          not null, primary key
#  name       :string
#  eval_type  :string
#  lang       :string
#  domain_id  :integer
#  eval_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Domain < ActiveRecord::Base
  belongs_to :domain
  has_many :domain_terms, primary_key: :eval_id
  has_many :labels, primary_key: :eval_id

  scope :no_test, -> { where(:eval_type => nil) }
  scope :test, -> { where(:eval_type => 'test') }

  def classify
    category_probabilities = {}
    Category.all.each { |category| category_probabilities[category.name.to_sym] = category_probability(category) }
    category_probabilities.sort_by { |_c, v| v }.reverse
  end

  def classify_k_nearest
    category_probabilities = neo_host.classify(0, 1)
    category_probabilities.blank? ? classify : category_probabilities.sort_by { |_c, v| v }.reverse
  end

  def neo_host
    Neo::Host.find_by(:eval_id => eval_id)
  end

  def category_probability(category)
    likelihood = 0
    domain_terms.includes(:term => :category_terms).each do |dt|
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
    Domain.test.each do |domain|
      eval = 1
      result = domain.classify_k_nearest
      # result[0..1].each_with_index do |(name, _val), i|
      #   if domain.labels.find { |label| label[name.to_sym] == 1 }
      #     mrr += eval / (i+1).to_f
      #     eval += 1
      #   end
      # end
      # all += domain.evaluated_classes.size

      r1 += 1 if (domain.evaluated_classes & result[0].flatten).present?
      r2 += 1 if (domain.evaluated_classes & result[0..1].flatten).present?
      all += 1

      puts "***************************************************************************************"
      puts "***************************************************************************************"
      puts "#{r1} #{r2} #{all} --- #{result} --- #{domain.labels.inspect}"
      puts "***************************************************************************************"
      puts "***************************************************************************************"
      puts "#{r1} #{r2} #{all} --- #{result} --- #{domain.labels.inspect}"
      puts "***************************************************************************************"
      puts "***************************************************************************************"
    end
  end

  def evaluated_classes
    labels.map { |label| label.categories }.flatten.uniq
  end

end
