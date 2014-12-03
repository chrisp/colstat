class ColonyMap < ActiveRecord::Base
  self.table_name = :colonies

  belongs_to :capsuleer_map
end
