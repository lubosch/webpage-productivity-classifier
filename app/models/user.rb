# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  lname                  :string
#  fname                  :string
#  username               :string
#  desktop_logger         :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:facebook, :twitter]

  has_many :user_application_pages
  has_many :application_pages, through: :user_application_pages
  has_many :applications, through: :application_pages
  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner
  has_many :application_activity_types

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        if identity.provider == "twitter"
          user = User.new(
              fname: auth.extra.raw_info.name ? auth.extra.raw_info.name : auth.info.nickname,
              lname: " ",
              username: auth.info.nickname || auth.uid,
              email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
              password: Devise.friendly_token[0, 20]
          )
        else
          user = User.new(
              fname: auth.extra.raw_info.first_name ? auth.extra.raw_info.first_name : " ",
              lname: auth.extra.raw_info.last_name ? auth.extra.raw_info.last_name : " ",
              username: auth.info.username || auth.uid,
              email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
              password: Devise.friendly_token[0, 20]
          )
        end
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def active_app?
    user_application_pages.last_chrome
  end

  def best_unclassified_apps
    best_apps = ActiveLearning::AppSelection.new(self).best_apps
    best_apps_id = best_apps.map{|app_id, _value| app_id}.first(10)

    ApplicationPage
        .where(:id => application_pages
                          .group(:application_id)
                          .where(application_id: best_apps_id)
                          .pluck('min("application_pages"."id")'))
  end


  def apps(since, till)
    user_application_pages.joins(:application_page => :application).ranged(since, till)
  end

  def apps_w_stats(since, till)
    apps(since, till).group(:application_id, :name).select('application_id, name, count(*) count, sum(length) length')
  end

end
