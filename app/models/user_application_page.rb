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

  delegate :connect_previous_tab, :url, to: :application_page

  before_create :default_values

  def default_values
    self.length ||= 0
    self.scroll_count ||= 0
    self.scroll_diff ||= 0
    self.scroll_up ||= 0
    self.scroll_down ||= 0
  end

  def tab_change(new_page)
    user.user_application_pages.create(application_page: new_page.application_page, tab_id: new_page.tab_id, app_type: new_page.app_type)
    new_page.connect_previous_tab(self)
  end

  def active?
    length == 0
  end

end
