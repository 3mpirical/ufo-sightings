class CreateHotspots < ActiveRecord::Migration[6.0]
  def change
    create_table :hotspots do |t|
      t.string :name
      t.st_point :lonlat, null: false, geographic: true

      t.timestamps
    end

    add_index :hotspots, :lonlat, using: :gist
  end
end
