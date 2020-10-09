class HotspotSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  attributes :id, :created_at, :updated_at, :name, :lonlat

  attribute :longitude do |object|
    object.lonlat&.longitude
  end

  attribute :latitude do |object|
    object.lonlat&.latitude
  end
end
