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

  def self.find_or_create_by_params(params)
    transaction do
      ap = ApplicationPage.find_by_url(params[:url])
      ap ? ap.compare_terms(params[:title], params[:meta_description], params[:headers], params[:tfidf]) : ap = create_by_params(params)
      ap
    end
  end

  def self.create_by_params(params)
    application = Application.find_or_create_by_params(params[:url])
    ap = ApplicationPage.create(application: application, url: params[:url], static: 0, user_static: 0)
    ap.create_terms(params[:title], params[:meta_description], params[:headers], params[:tfidf])
    neo_app = ap.find_or_create_neo_app_page
    neo_app.set_referrer(params[:referrer]) if params[:referrer].present?
    ap
  end

  def create_terms(title, description, headers, tfidf)
    if title.present?
      title_terms = Term.create_terms_from_sentence(title)
      write_in_db(title_terms, 'title')
    end
    if description.present?
      description_terms = Term.create_terms_from_sentence(description)
      write_in_db(description_terms, 'description')
    end
    if headers.present?
      header_terms = Term.create_text_terms(headers)
      write_in_db(header_terms, 'header')
    end
  end

  def write_in_db(terms, type)
    # binding.pry
    terms.each do |term, count|
      at = application_terms.where(term: term, term_type: type).first_or_initialize(tf: 0)
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
