# == Schema Information
#
# Table name: applications
#
#  id          :integer          not null, primary key
#  name        :string
#  eval_type   :string
#  lang        :string
#  eval_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  url         :string
#  static      :integer
#  user_static :integer
#

class Application < ActiveRecord::Base
  has_many :application_terms, through: :application_pages
  has_many :labels #, primary_key: :eval_id
  has_many :application_pages
  has_one :application_cluster, as: :application
  has_many :application_activity_types

  scope :no_test, -> { where(:eval_type => nil) }
  scope :test, -> { where(:eval_type => 'test') }

  def detect_language
    guess = CLD.detect_language(application_pages.joins(:application_terms => :term).pluck('terms.text'))
    guess[:code] if guess[:reliable]
  end

  def classify
    activity_type_probabilities = {}
    ActivityType.all.each { |activity_type| activity_type_probabilities[activity_type.name.to_sym] = activity_type_probability(activity_type) }
    activity_type_probabilities.sort_by { |_c, v| v.nan? ? -999999999 : v }.reverse
  end

  def classify_knn
    category_probabilities = neo_host.classify(0, 1)
    category_probabilities.blank? ? classify : category_probabilities.sort_by { |_c, v| v }.reverse
  end

  def neo_host
    Neo::App.find_by(:application_id => self.id)
  end

  def activity_type_probability(category)
    likelihood = 0
    application_terms.includes(:term => :activity_type_terms).each do |dt|
      likelihood += dt.generating_multinomial_likelihood(category)
      # likelihood += dt.generating_bernouolli_likelihood(category)
    end
    likelihood + Math.log2(category.probability + 1)
  end

  def evaluated_classes
    application_activity_types.joins(:activity_type).pluck('name').map(&:to_sym).uniq
  end

  def self.extract_domain(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    URI.parse(url).host.downcase
  end

  def self.app_lang(url)
    :en
  end

  def self.app_name(url)
    url.split(/[\/\\]+/)[-1]
  end

  def self.web_name(url)
    name = extract_domain(url)
    name.split('.')[0..-2].join(' ').capitalize
  end

  def self.find_or_create_by_params(url)
    domain = uri?(url) ? extract_domain(url) : url
    name = uri?(url) ? web_name(url) : app_name(url)
    Application.where(url: domain).first_or_create(eval_type: 'experiment', static: 0, user_static: 0, name: name)
  end

  def self.uri?(url)
    url.match URI::regexp(%w(http https))
  end

end
