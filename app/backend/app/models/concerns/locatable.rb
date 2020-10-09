module Locatable
  extend ActiveSupport::Concern

  included do
    scope :within, -> (long_param, lat_param, radius_in_miles = 1) {
      longitude = long_param ? long_param.to_f : nil
      latitude = lat_param ? lat_param.to_f : nil
      radius = radius_in_miles ? radius_in_miles.to_i * 1609.34 : nil

      if longitude && latitude
        where(
          "ST_DWithin(lonlat, 'POINT(? ?)', ?)",
          longitude,
          latitude,
          radius || 1,
        )
      end
    }
  end

  def self.point_is_valid?(longitude, latitude, point)
    (
      longitude &&
      longitude >= -180 &&
      longitude <= 180 &&
      latitude &&
      latitude >= -90 &&
      latitude <= 90
    )
  end
end
