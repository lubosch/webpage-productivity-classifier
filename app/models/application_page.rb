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
  has_many :application_activity_types

  delegate :name, to: :application, prefix: true

  def self.find_or_create_by_params(params)
    transaction do
      # ap = ApplicationPage.find_by_url(params[:url])
      # ap ? ap.compare_terms(params[:title], params[:meta_description], params[:headers], params[:tfidf]) : ap =
      create_by_params(params)
      # ap
    end
  end

  def self.create_by_params(params)
    application = Application.find_or_create_by_params(params[:url])
    ap = ApplicationPage.where(application: application, url: params[:url]).first_or_create(static: 0, user_static: 0)
    ap.create_terms(params[:title], params[:meta_description], params[:headers], params[:tfidf])
    neo_app = ap.find_or_create_neo_app_page
    neo_app.set_referrer(params[:referrer]) if params[:referrer].present?
    ap
  end

  def create_terms(title, description, headers, tfidf)
    if title.present? && application_terms.titles.blank?
      title_terms = Term.create_terms_from_sentence(title)
      write_in_db(title_terms, 'title')
    end
    if description.present? && application_terms.descriptions.blank?
      description_terms = Term.create_terms_from_sentence(description)
      write_in_db(description_terms, 'description')
    end
    if headers.present? && application_terms.headers.blank?
      header_terms = Term.create_text_sterms(headers)
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

end
