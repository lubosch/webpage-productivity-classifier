# == Schema Information
#
# Table name: categories
#
#  id              :integer          not null, primary key
#  name            :text
#  count           :integer
#  probability     :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  vocabulary_size :integer
#  terms_count     :integer
#

class Category < ActiveRecord::Base

  has_many :category_terms, :dependent => :delete_all
  CATEGORIES = [:adult, :spam, :news_editorial, :commercial, :educational_research, :discussion, :personal_leisure, :media, :database]

  def update_probabilities
    update(:terms_count => category_terms.sum(:count), :vocabulary_size => category_terms.count)
    category_terms.update_all("probability = count / #{terms_count}, multinomial_probability = (count+1) / #{terms_count + vocabulary_size.to_f}")
  end

  def add_terms(domain)
    @ct ||= {}
    domain.domain_terms.includes(:term).each do |dt|
      if dt.term
        @ct[dt.term.id] ||= CategoryTerm.new(:category => self, :term => dt.term, :count => 0)
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
    sum = CATEGORIES.inject(0) { |sum, category| sum + Label.no_test.where(category => 1).count }
    Category.all.each { |category| category.update_prior_probabilities(sum) }
  end

  def add_label(label)
    CATEGORIES.each { |category| @categories[category].prior_probability.count += 1 if label[category] == 1 }
  end

end
