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
        app_act_type = ApplicationActivityType.where(application_page: app_page, user: user).first_or_initialize
        app_act_type.update(activity_type: act_type, application_page: app_page, application: app_page.application, based_on: 'user_defined', is_work: app_page_hash[:is_work])
      end if result[:application_pages]
    end
  end

end
