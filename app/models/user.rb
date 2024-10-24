class User < ApplicationRecord
  attr_readonly :id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :company
  belongs_to :role
  has_many :estimates
  has_many :invoices

  include Devise::Models::DatabaseAuthenticatable

  #
  # Replacement for token generation for Devise
  #
  include TokenAuthenticatable

  before_save :ensure_authentication_token

  def name
    "#{first_name} #{last_name}".strip
  end

  def email=(new_email)
    self[:email] = new_email.downcase if new_email.present?
  end

  def email_confirmed
    confirmed_at.present? && unconfirmed_email.blank?
  end
end
