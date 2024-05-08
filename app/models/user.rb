# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string
#  password_digest :string
#  role            :string
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email        (email) UNIQUE
#  index_users_on_lower_email  (lower((email)::text)) UNIQUE
#  index_users_on_token        (token) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_secure_token
  enum user_role: { regular: nil, administrator: 'admin' }

  EMAIL_REGEX = /\A\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+\z/
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: EMAIL_REGEX }
  validates :first_name, presence: true, length: { minimum: 2 }
  has_many :bookings, dependent: :destroy
  has_many :flights, through: :bookings
  def admin?
    role == 'admin'
  end

  def password_match(plain_password)
    BCrypt::Password.new(password_digest) == plain_password
  end
end
