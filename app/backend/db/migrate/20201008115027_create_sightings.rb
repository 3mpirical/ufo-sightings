class CreateSightings < ActiveRecord::Migration[6.0]
  def change
    create_table :sightings do |t|
      t.datetime :sighting_date
      t.string :shape
      t.string :city
      t.string :state
      t.integer :duration_seconds
      t.string :duration_string
      t.text :comments
      t.st_point :lonlat, null: false, geographic: true

      t.timestamps
    end

    add_index :sightings, :lonlat, using: :gist
  end
end
