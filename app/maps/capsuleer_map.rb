class CapsuleerMap < ActiveRecord::Base
  self.table_name = :capsuleers

  has_many :colony_maps
end
