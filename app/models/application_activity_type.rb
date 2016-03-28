# == Schema Information
#
# Table name: application_activity_types
#
#  id                  :integer          not null, primary key
#  activity_type_id    :integer
#  application_id      :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  based_on            :string
#  application_page_id :integer
#  is_work             :integer
#  user_id             :integer
#

class ApplicationActivityType < ActiveRecord::Base
  belongs_to :activity_type
  belongs_to :application
  belongs_to :user
  belongs_to :application_page

  def self.define_by_user(results, user)
    results.each do |result|
      act_type = ActivityType.find_by(id: result[:id])
      result[:application_pages].each do |app_page_hash|
        app_page = ApplicationPage.find_by_id(app_page_hash[:id])
        app_act_type = ApplicationActivityType.find_by(application_page: app_page, user: user)
        if app_act_type
          app_act_type.update(activity_type: act_type, application: app_page.application, based_on: 'user_defined', is_work: app_page_hash[:is_work])
        else
          app_act_type = ApplicationActivityType.create(user: user, activity_type: act_type, application_page: app_page, application: app_page.application, based_on: 'user_defined', is_work: app_page_hash[:is_work])
          app_act_type.create_activity_type_terms if ApplicationActivityType.where(application_page: app_page).count == 1
        end
      end if result[:application_pages]
    end
  end

  def create_activity_type_terms
    ActivityTypeTerm.transaction do
      application_page.application_terms.each do |ap_term|
        act_type_term = ActivityTypeTerm.where(term_type: ap_term.term_type, term_id: ap_term.term_id, activity_type_id: self.activity_type_id).first_or_initialize(tf: 0)
        act_type_term.update(tf: act_type_term.tf + ap_term.tf)
      end
    end
  end

end
