class Role < ApplicationRecord
  belongs_to :company
  has_many :users
end
