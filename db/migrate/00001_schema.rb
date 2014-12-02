class Schema < ActiveRecord::Migration
  def change
    create_table :capsuleers, force: true do |t|
      t.string :name
    end
  end
end
