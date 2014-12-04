class Schema < ActiveRecord::Migration
  def change
    create_table :capsuleers, force: true do |t|
      t.integer :resource_id
      t.string  :name
      t.timestamps
    end

    create_table :colonies, force: true do |t|
      t.integer :resource_id
      t.belongs_to :capsuleers
      t.string  :name
      t.timestamps
    end

    create_table :planet_schematics, force: true do |t|
      t.integer :resource_id
      t.belongs_to :colonies
      t.string  :name
      t.timestamps
    end
  end
end
