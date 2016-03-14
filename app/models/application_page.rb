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
#

class ApplicationPage < ActiveRecord::Base
  belongs_to :application
  has_many :application_terms
  has_many :terms, through: :application_terms
  has_many :application_activity_types
  has_many :user_application_pages

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

end
