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
#  app_type    :string
#

class Application < ActiveRecord::Base
  has_many :application_terms, through: :application_pages
  has_many :labels #, primary_key: :eval_id
  has_many :application_pages
  has_one :application_cluster, as: :application
  has_many :application_activity_types
  has_many :application_type_probabilities

  scope :no_test, -> { where(:eval_type => nil) }
  scope :test, -> { where(:eval_type => 'test') }

  def detect_language
    guess = CLD.detect_language(application_pages.joins(:application_terms => :term).pluck('terms.text'))
    guess[:code] if guess[:reliable]
  end

  def classify
    activity_type_probabilities = {}
    ActivityType.all.each { |activity_type| activity_type_probabilities[activity_type.name.to_sym] = activity_type_probability(activity_type) }
    activity_type_probabilities = normalize(activity_type_probabilities)
    activity_type_probabilities.sort_by { |_c, v| v }.reverse
  end

  def normalize(activity_type_probabilities)
    values = activity_type_probabilities.map { |_c, v| v }
    min = values.min
    max = values.max
    normalized = activity_type_probabilities.map { |c, v| [c, (v-min)/(max-min)] }
    sum = normalized.sum { |_c, v| v }
    normalized.map { |c, v| [c, v/sum] }
  end

  def classify_precomputed(method)
    # application_type_probabilities.where(method: method, application_page: nil).order(value: :desc).joins(:activity_type).pluck(:name, :value)
    application_type_probabilities.where(method: method, application_page: nil).order(value: :desc).joins(:activity_type).pluck(:name).map(&:to_sym)
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
    end
    category.probability == 0 ? likelihood + Math.log2(category.default_probability) : likelihood + Math.log2(category.probability)
  end

  def evaluated_classes
    application_activity_types.joins(:activity_type).pluck('name').map(&:to_sym).uniq
  end

  def self.extract_domain(url)
    url = "http://#{url}" if Addressable::URI.parse(url).scheme.nil?
    Addressable::URI.parse(url).host.downcase
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
