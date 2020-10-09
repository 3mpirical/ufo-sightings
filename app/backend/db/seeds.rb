# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# PostGIS point factory
factory = RGeo::Geographic.spherical_factory(srid: 4326)

hotspots = [
  {
    name: "The White House",
    latitude: 38.897663,
    longitude: -77.036575
  },
  {
    name: "World’s Tallest Thermometer",
    latitude: 35.26644,
    longitude: -116.07275
  },
  {
    name: "Area 51",
    latitude: 37.233333,
    longitude: -115.808333
  },
  {
    name: "Disney World’s Magic Kingdom",
    latitude: 37.233333,
    longitude: -115.808333
  },
  {
    name: "Pop's Soda Bottle",
    latitude: 35.658340,
    longitude: -97.335490
  }
]

transformed_hotspots = hotspots.map do |hotspot|
  hotspot[:lonlat] = factory.point(hotspot[:longitude], hotspot[:latitude])
  hotspot.delete(:latitude)
  hotspot.delete(:longitude)
  hotspot
end

Hotspot.create(transformed_hotspots)

puts "_____Seeded_Hotspots_____"
