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
      ap = ApplicationPage.find_by_url(url)
      ap ? ap.compare_terms(params[:title], params[:meta_description], params[:headers], params[:tfidf]) : ap = create_by_params(params)
      ap
    end
  end

  def self.create_by_params(params)
    application = Application.find_or_create_by_params(params[:url])
    ap = ApplicationPage.create(application: application, url: params[:url], static: 0, user_static: 0)
    ap.create_terms(params[:title], params[:meta_description], params[:headers], params[:tfidf])
    ap.create_neo_app_page(referrer)
    ap
  end

  def create_terms(title, description, headers, tfidf)
    title_terms = Term.create_terms_from_sentence(title)
    description_terms = Term.create_terms_from_sentence(description)
    header_terms = Term.create_text_terms(headers)

    write_in_db(title_terms, 'title')
    write_in_db(description_terms, 'description')
    write_in_db(header_terms, 'header')
  end

  def write_in_db(terms, type)
    terms.each do |term, count|
      at = application_terms.where(term: term, type: type).find_or_initialize(tf: 0)
      at.tf += count
      at.save
    end
  end

  def create_neo_app_page(referrer)
    neo_app_page.set_referrer(referrer)
  end

  def neo_app_page
    Neo::AppPage.find_or_create_by_id(id, url, application.id, application.url)
  end

  def compare_terms(title, description, headers, tfidf)
    #TODO should evaluate if page changed or is static
  end

end
