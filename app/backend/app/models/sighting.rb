class Sighting < ApplicationRecord
  include Locatable
  include Filterable
  include Orderable

  # FILTERS
  filterable_by :shape, ->(shape) { where(shape: shape) }
  filterable_by :city, ->(city) { where(city: city) }
  filterable_by :state, ->(state) { where(state: state) }
  filterable_by :duration_seconds, ->(duration_seconds) {
    where(duration_seconds: duration_seconds)
  }

  # Gets all sightings within the radius of the given longitude and latitude
  filterable_by_with_params :radius, ->(radius, params) {
    within(params[:longitude], params[:latitude], radius)
  }

  # Data to be used in location search and nearest ordering
  filterable_data :longitude
  filterable_data :latitude

  orderable_by(
    :created_at,
    :updated_at,
    :duration_seconds,
    :shape,
    :sighting_date,
  )

  # VALIDATIONS
  validates :shape, length: { maximum: 500, message: "Shape cannot be more than 500 characters" }
  validates :duration_string, length: { maximum: 500, message: "Duration string cannot be more than 500 characters" }
  validates :comments, length: { maximum: 30000, message: "Comments cannot be more than 30000 characters" }
  validate :sighting_date, :cannot_occur_in_future

  private

  def cannot_occur_in_future
    return unless sighting_date && sighting_date > DateTime.current

    errors.add(:sighting_date, "Sighting date cannot be in the future")
  end
end
