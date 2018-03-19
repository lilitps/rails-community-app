# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string
#  email              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  crypted_password   :string
#  persistence_token  :string
#  admin              :boolean          default(FALSE)
#  activated_at       :datetime
#  locale             :string           default("en")
#  password_salt      :string
#  perishable_token   :string
#  login_count        :integer          default(0), not null
#  failed_login_count :integer          default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string
#  last_login_ip      :string
#  active             :boolean          default(FALSE)
#  approved           :boolean          default(FALSE)
#  confirmed          :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email              (email) UNIQUE
#  index_users_on_last_request_at    (last_request_at)
#  index_users_on_perishable_token   (perishable_token) UNIQUE
#  index_users_on_persistence_token  (persistence_token) UNIQUE
#

# An application user
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy,
                                  inverse_of: 'follower'
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy,
                                   inverse_of: 'followed'
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }

  acts_as_authentic do |c|
    c.validates_format_of_email_field_options = { with: Authlogic::Regex.email_nonascii }
    c.validates_length_of_email_field_options = { maximum: 255 }
    c.validates_uniqueness_of_email_field_options = { case_sensitive: false }
    c.merge_validates_length_of_password_field_options presence: true, minimum: 6, allow_nil: true
    c.perishable_token_valid_for = 2.hours
  end

  # Activates an account.
  def activate
    update_attributes(active: true, approved: true, confirmed: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    reset_perishable_token!
    UserMailer.account_activation(self).deliver_now
  end

  # Sends password reset email.
  def send_password_reset_email
    reset_perishable_token!
    UserMailer.password_reset(self).deliver_now
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end
end
