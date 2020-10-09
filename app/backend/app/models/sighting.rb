class Sighting < ApplicationRecord
  include Locatable

  # VALIDATIONS
  validates :shape, length: { maximum: 500, message: "Shape cannot be more than 500 characters" }
  validates :duration_string, length: { maximum: 500, message: "Duration string cannot be more than 500 characters" }
  validates :duration_seconds, numericality: { only_integer: true, message: "Duration seconds must be of integer type" }
  validates :comments, length: { maximum: 30000, message: "Comments cannot be more than 30000 characters" }
  validate :sighting_date, :cannot_occur_in_future

  private

  def cannot_occur_in_future
    return unless sighting_date && sighting_date > DateTime.current

    errors.add(:sighting_date, "Sighting date cannot be in the future")
  end
end
