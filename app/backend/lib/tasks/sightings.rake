namespace :sightings do
  desc "These tasks perform sightings related manipulation of data"

  task populate: :environment do
    puts "Preparing Data..."

    options = {
      key_mapping: {
        "sighting_date/time".to_sym => :sighting_date,
        "duration_(seconds)".to_sym => :duration_seconds,
        "duration_(hours/min)".to_sym => :duration_string,
      }
    }

    csv_path = Rails.root.join("data", "ufo_sightings.csv")
    data = SmarterCSV.process(csv_path, options)

    # SmarterCSV has hash_transforms, but the usage is not well documented
    # Traditional mapping has been used for time's sake

    # transform lonlat
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    data.each do |record|
      location = record["site_location_lat/lng".to_sym].split(" ")
      latlong = location.last.delete("(").delete(")").split(":")
      record.delete("site_location_lat/lng".to_sym)

      record[:lonlat] = factory.point(latlong[1], latlong[0])
      record[:state] = location[location.length - 2]
      record[:city] = location.slice(0..location.length - 3).join(" ")
    end

    # transform datetime
    data.each do |record|
      record[:sighting_date] = DateTime.strptime(
        record[:sighting_date],
        "%m/%d/%y %H:%M"
      ) rescue nil

      # validations should handle cases where invalid data is set in distant future
      # This assumes we don't have sighting data from before year 1900
      if record[:sighting_date] && record[:sighting_date] > DateTime.current
        record[:sighting_date] -= 100.years
      else
        record
      end
    end

    # Preprocessing for batch insert
    default = {
      sighting_date: nil,
      shape: nil,
      city: nil,
      state: nil,
      duration_seconds: nil,
      duration_string: nil,
      comments: nil
    }
    data = data.map { |record| default.merge(record) }
    data = data.each_slice(1000).to_a

    # Insert data
    puts "Populating Data..."
    Parallel.each(data) do |sightings|
      ActiveRecord::Base.connection_pool.with_connection do
        Sighting.import(sightings, raise_error: true)
      end
    end

    puts "Data Populated"
  end

  task json_by_hotspot: :environment do
    # Writing the files to json is by far the biggest performance detriment
    # so it makes sense to parallelize some of the work here by turning the
    # instances into hashes ahead of serialization.
    puts "Getting Sightings By Hotspot..."
    hotspots_with_sightings = Parallel.map(Hotspot.all) do |hotspot|
      {
        hotspot: hotspot.attributes,
        sightings: Sighting.within(
          hotspot.lonlat.lon,
          hotspot.lonlat.lat,
          750
        ).map(&:attributes)
      }
    end

    puts "Writing Json..."
    File.open(Rails.root.join("output", "hotspots_with_sightings.json"),"w") do |f|
      f.write(hotspots_with_sightings.to_json)
    end

    puts "Wrote output/hotspots_with_sightings.json"
  end
end
