# == Schema Information
#
# Table name: application_pages
#
#  id             :integer          not null, primary key
#  application_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  url            :string
#  static         :integer
#  user_static    :integer
#  app_type       :string
#

class ApplicationPage < ActiveRecord::Base
  belongs_to :application
  has_many :application_terms
  has_many :terms, through: :application_terms
  has_many :application_activity_types
  has_many :user_application_pages
  has_many :application_type_probabilities
  has_many :work_probabilities
  has_one :application_cluster, as: :application

  delegate :name, to: :application, prefix: true

  def self.find_or_create_by_params(params)
    params = preprocess_params_words(params)
    application = Application.find_or_create_by_params(params[:url])
    ap = ApplicationPage.where(application: application, url: params[:url]).last
    ap = create_by_params(application, params) if !ap || ap.id && !ap.identical?(params[:title], params[:tfidf])
    neo_app = ap.find_or_create_neo_app_page
    neo_app.set_referrer(params[:referrer]) if params[:referrer].present?
    ap
  end

  def detect_language
    guess = CLD.detect_language(application_terms.joins(:term).pluck('terms.text'))
    guess[:code] if guess[:reliable]
  end

  def self.create_by_params(application, params)
    transaction do
      ap = ApplicationPage.create(application: application, url: params[:url], static: 0, user_static: 0)
      ap.create_terms(params[:title], params[:meta_description], params[:headers], params[:tfidf])
      lang = ap.detect_language
      application.update(lang: lang) if !application.lang && lang
      ap
    end
  end

  def create_terms(title, description, headers, tfidf)
    if title.present? && application_terms.titles.blank?
      title_terms = Term.create_terms_from_array(title)
      write_in_db(title_terms, 'title')
    end
    if description.present? && application_terms.descriptions.blank?
      description_terms = Term.create_terms_from_array(description)
      write_in_db(description_terms, 'description')
    end
    if headers.present? && application_terms.headers.blank?
      header_terms = Term.create_terms_from_array(headers)
      write_in_db(header_terms, 'header')
    end

    if tfidf.present? && application_terms.texts.blank?
      tfs = Term.create_terms_from_array(tfidf)
      write_in_db(tfs, 'text')
    end

  end

  def titles
    application_terms.titles.joins(:term).pluck(:text).join(' ')
  end

  def write_in_db(terms, type)
    terms.each do |term, count|
      at = application_terms.where(term: term.id, term_type: type).first_or_initialize(tf: 0)
      at.tf += count
      at.save
    end
  end

  def connect_previous_tab(old_page)
    find_or_create_neo_app_page.set_switch(old_page.url)
  end

  def find_or_create_neo_app_page
    Neo::AppPage.find_or_create_by_id(id, url, application.id, application.url)
  end

  def compare_terms(title, description, headers, tfidf)
    #TODO should evaluate if page changed or is static
  end

  def identical?(title, text)
    act_text = application_terms.texts.joins(:term).pluck(:text)
    words = text.present? ? text.map(&:first) : []

    act_titles = application_terms.titles.joins(:term).pluck(:text)
    titles = title.present? ? title.map(&:first) : []

    if (act_text & words).size < [act_text.size, words.size].min*0.8 || (act_titles & titles).size < [act_titles.size, titles.size].min*0.7
      return false
    elsif (act_text & words).size < [act_text.size, words.size].min || (act_titles & titles).size < [act_titles.size, titles.size].min
      remove_different((act_titles-titles), (act_text - words))
    end
    true
  end

  def neo_app_page
    Neo::AppPage.find_by(application_page_id: self.id)
  end

  def remove_different(titles, words)
    application_terms.joins(:term).where('text IN (?)', titles).where(term_type: ApplicationTerm::TERM_TYPES[:title]).destroy_all
    application_terms.joins(:term).where('text IN (?)', words).where(term_type: ApplicationTerm::TERM_TYPES[:text]).destroy_all
  end

  def self.preprocess_params_words(params)
    new_params = params
    new_params[:title] = params[:title].present? ? preprocess_words(params[:title].split) : []
    new_params[:meta_description] = params[:meta_description].present? ? preprocess_words(params[:meta_description].split) : []
    new_params[:tfidf] = params[:tfidf].present? ? preprocess_words(params[:tfidf]) : []
    if params[:headers].present?
      headers = {}
      params[:headers].map(&:split).flatten.each { |word| headers[word] ? headers[word] += 1 : headers[word] = 1 }
      new_params[:headers] = preprocess_words(headers)
    else
      new_params[:headers] = []
    end
    new_params
  end

  def self.preprocess_words(words)
    words = words.map do |word, tf|
      filter = Stopwords::Snowball::Filter.new('en')

      word = word.downcase
      # word = word.stem
      word = nil if word.length < 3 || !word[/\p{L}/] || filter.stopword?(word)
      word ? [word, tf] : nil
    end
    words.compact
  end

  def classify
    activity_type_probabilities = {}
    ActivityType.all.each { |activity_type| activity_type_probabilities[activity_type.name.to_sym] = activity_type_probability(activity_type) }
    activity_type_probabilities = normalize(activity_type_probabilities)
    # activity_type_probabilities.sort_by { |_c, v| v.nan? ? -999999999 : v }.reverse
  end

  def classify_w
    work_probabilities = {}
    Work.all.each { |work| work_probabilities[work.name.to_sym] = work_probability(work) }
    work_probabilities = normalize(work_probabilities)
    # work_probabilities
    # activity_type_probabilities.sort_by { |_c, v| v.nan? ? -999999999 : v }.reverse
  end


  def normalize(activity_type_probabilities)
    values = activity_type_probabilities.map { |_c, v| v }
    # return activity_type_probabilities.map { |c, v| [c, 1/13.0] } if values.size == 1
    min = values.min
    max = values.max
    if values.present? && (max-min == 0)
      activity_type_probabilities.map { |c, v| [c, 1/activity_type_probabilities.size] }
    elsif values.present?
      normalized = activity_type_probabilities.map { |c, v| [c, (v-min)/(max-min)] }
      sum = normalized.sum { |_c, v| v }
      normalized.map { |c, v| [c, v/sum] }
    else
      []
    end
  end

  def classify_knn
    return [] if neo_app_page.blank?
    category_probabilities = neo_app_page.classify(3)
    category_probabilities = normalize(category_probabilities)
    # category_probabilities.sort_by { |_c, v| v }.reverse
    # category_probabilities
  end

  def classify_knn_w
    return [] if neo_app_page.blank?
    category_probabilities = neo_app_page.classify_w(5)
    category_probabilities = normalize(category_probabilities)
    # category_probabilities.sort_by { |_c, v| v }.reverse
    # category_probabilities
  end

  def activity_type_probability(category)
    likelihood = 0
    application_terms.includes(:term => :activity_type_terms).each do |dt|
      # likelihood += dt.generating_multinomial_likelihood(category)
      likelihood += dt.generating_bernouolli_likelihood(category)
    end
    likelihood + Math.log2(category.probability)
  end

  def work_probability(category)
    likelihood = 0
    application_terms.includes(:term => :work_terms).each do |dt|
      # likelihood += dt.generating_w_multinomial_likelihood(category)
      likelihood += dt.generating_bernouolli_likelihood(category)
    end
    likelihood + Math.log2(category.probability + 1)
  end

  def evaluated_classes
    classes = application_activity_types.joins(:activity_type).pluck('name').map(&:to_sym).uniq
    classes.blank? ? application.evaluated_classes : classes
  end

  def evaluated_classes_w
    classes = application_activity_types.joins(:work_rel).pluck('name').map(&:to_sym).uniq
    # classes.blank? ? application.evaluated_classes_w : classes
    # classes.blank? ? application.evaluated_classes_w : classes
  end

  def classify_precomputed(method)
    # application_type_probabilities.where(method: method, application_page: nil).order(value: :desc).joins(:activity_type).pluck(:name, :value)
    application_type_probabilities.where(method: method).order(value: :desc).joins(:activity_type).pluck(:name).map(&:to_sym)
  end

  def classify_precomputed_intelligent(method)
    # application_type_probabilities.where(method: method, application_page: nil).order(value: :desc).joins(:activity_type).pluck(:name, :value)
    klasses = application_type_probabilities.where(method: method).order(value: :desc).joins(:activity_type).pluck(:name).map(&:to_sym)
    app_probability(method) > 0.01 ? klasses : []
  end


  def app_probability(method)
    apptype_probabilities = ApplicationTypeProbability.where(application_page: self, method: method).pluck(:value)
    # apptype_probabilities.sum { |prob| (prob == 0 || prob.nan?) ? 0 : prob*Math.log10(prob) }
    # apptype_probabilities.sum { |prob| (prob == 0 || prob.nan?) ? 0 : prob*Math.log10(prob) }
    return 0 if apptype_probabilities.blank? || apptype_probabilities.size == 1 && apptype_probabilities[0].nan?
    return apptype_probabilities[0] if apptype_probabilities.size == 1
    apptype_probabilities = apptype_probabilities.sort_by { |at| at.nan? ? 0 : at }
    res = apptype_probabilities[-1] - apptype_probabilities[-2]
    res.nan? ? 0 : res
  end


  def classify_w_precomputed(method)
    # application_type_probabilities.where(method: method, application_page: nil).order(value: :desc).joins(:activity_type).pluck(:name, :value)
    work_probabilities.where(method: method).order(value: :desc).joins(:work).pluck(:name).map(&:to_sym)
  end

  def classify_precomputed_cumm
    # application_type_probabilities.where(method: method, application_page: nil).order(value: :desc).joins(:activity_type).pluck(:name, :value)
    cumm = {}
    prob_knn = Hash[application_type_probabilities.where(method: ApplicationTypeProbability::METHODS[:knn]).order(value: :desc).joins(:activity_type).pluck(:name, :value)]
    prob_mnb = Hash[application_type_probabilities.where(method: ApplicationTypeProbability::METHODS[:mnb]).order(value: :desc).joins(:activity_type).pluck(:name, :value)]
    prob_mnb.each { |klass, prob| cumm[klass] = prob + ((prob_knn[klass] && !prob_knn[klass].nan?) ? prob_knn[klass] : 0) }

    sorted = cumm.sort_by(&:last).reverse
    diff = sorted[0][-1] - sorted[1][-1]
    diff > 0.04 ? cumm : []

    # cumm

  end

  def classify_w_precomputed_cumm
    # application_type_probabilities.where(method: method, application_page: nil).order(value: :desc).joins(:activity_type).pluck(:name, :value)
    cumm = {}
    prob_knn = Hash[work_probabilities.where(method: ApplicationTypeProbability::METHODS[:knn]).order(value: :desc).joins(:work).pluck(:name, :value)]
    prob_mnb = Hash[work_probabilities.where(method: ApplicationTypeProbability::METHODS[:mnb]).order(value: :desc).joins(:work).pluck(:name, :value)]
    prob_mnb.each { |klass, prob| cumm[klass] = 1 if prob == 1 && (prob_mnb[klass].nan? || prob_mnb[klass] != 0) }


  end


end
