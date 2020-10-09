namespace :sightings do
  desc "These tasks perform sightings related manipulation of data"

  task populate: :environment do
    puts "Preparing Data..."
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    options = {
      key_mapping: {
        "sighting_date/time".to_sym => :sighting_date,
        "duration_(seconds)".to_sym => :duration_seconds,
        "duration_(hours/min)".to_sym => :duration_string,
      },
    }

    data = SmarterCSV.process(Rails.root.join("data", "ufo_sightings.csv"), options)

    # SmarterCSV has hash_transforms, but the usage is not well documented
    # Traditional mapping has been used for time's sake
    # transform lonlat
    data.map do |record|
      latlong = record["site_location_lat/lng".to_sym]
        .split(" ")
        .last
        .delete("(")
        .delete(")")
        .split(":")

      record.delete("site_location_lat/lng".to_sym)
      record[:lonlat] = factory.point(latlong[1], latlong[0])
    end

    # transform datetime
    data.map do |record|
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

    puts "Populating Data..."
    Parallel.each(data) do |sighting|
      ActiveRecord::Base.connection_pool.with_connection do
        Sighting.create(sighting)
      end
    end

    puts "Data Populated"
  end

  task json_by_hotspot: :environment do
    # Writing the files to json is by far the biggest performance detriment
    # so it makes sense to parallelize some of the work here
    puts "Getting Sightings By Hotspot..."
    hotspots_with_sightings = Parallel.map(Hotspot.all) do |hotspot|
      {
        hotspot: hotspot,
        sightings: Sighting.within(
          hotspot.lonlat.lon,
          hotspot.lonlat.lat,
          750
        )
      }.to_json
    end

    puts "Writing Json..."
    File.open(Rails.root.join("output", "hotspots_with_sightings.json"),"w") do |f|
      f.write(hotspots_with_sightings.to_json)
    end

    puts "Wrote output/hotspots_with_sightings.json"
  end
end
