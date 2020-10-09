class SightingSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes(
    :id,
    :created_at,
    :updated_at,
    :sighting_date,
    :shape,
    :duration_seconds,
    :duration_string,
    :comments,
    :lonlat
  )

  attribute :longitude do |object|
    object.lonlat&.longitude
  end

  attribute :latitude do |object|
    object.lonlat&.latitude
  end
end
