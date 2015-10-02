# == Schema Information
#
# Table name: user_application_pages
#
#  id                  :integer          not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  application_page_id :integer
#  user_id             :integer
#  length              :float
#  scroll_count        :integer
#  scroll_diff         :integer
#  tab_id              :integer
#  app_type            :integer
#  scroll_up           :integer
#  scroll_down         :integer
#

class UserApplicationPage < ActiveRecord::Base

  belongs_to :application_page
  belongs_to :user

  scope :last_chrome, -> { joins(:application_page).where(app_type: 'chrome') }
  scope :today, -> { where(created_at: 14.days.ago.at_beginning_of_day..DateTime.now) }

  delegate :connect_previous_tab, :url, :application_name, :application_id, to: :application_page


  before_create :default_values

  def default_values
    self.length ||= 0
    self.scroll_count ||= 0
    self.scroll_diff ||= 0
    self.scroll_up ||= 0
    self.scroll_down ||= 0
  end

  def tab_change(old_page)
    user.user_application_pages.create(application_page: application_page, tab_id: tab_id, app_type: app_type)
    # new_page.connect_previous_tab(self)
    application_page.connect_previous_tab(old_page) if old_page
  end

  def active?
    length == 0
  end

end
