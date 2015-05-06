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

  def classify
    category_probabilities = {}
    Category.all.each { |category| category_probabilities[category.name] = category_probability(category) }
    category_probabilities = category_probabilities.sort_by { |_c, v| v }.reverse
    category_probabilities
  end

  def category_probability(category)
    likelihood = domain_terms.includes(:term => :category_terms).inject(0) { |result, dt| result + dt.generating_likelihood(category) }
    likelihood * (1-category.probability)
  end

  def self.experiment
    mrr=0
    all = 0
    Domain.joins(:labels).all.each do |domain|
      if Random.rand > 0.95
        eval = 1
        result = domain.classify
        result.each_with_index do |(name, val), i|
          if domain.labels.find { |label| label[name.to_sym] == 1 }
            mrr += eval / (i+1).to_f
            eval += 1
            all += 1
          end
        end

        puts "#{mrr} #{all} --- #{result} --- #{domain.labels}"
      end
    end
  end

end
