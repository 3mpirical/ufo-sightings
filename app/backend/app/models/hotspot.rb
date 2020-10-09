class Hotspot < ApplicationRecord
  include Locatable

  # VALIDATIONS
  validates :name, uniqueness: true
  validates :name, length: { maximum: 500, message: "Name cannot be more than 500 characters" }
end
