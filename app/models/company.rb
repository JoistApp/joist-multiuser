class Company < ApplicationRecord
  has_many :users
  has_many :roles
  has_many :estimates
  has_many :invoices
end
