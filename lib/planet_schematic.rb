class PlanetSchematic
  attr_accessor :eve_db
  def initialize(init_eve_db)
    self.eve_db = init_eve_db
  end

  def name_for_id(schem_id)
    eve_db.db.execute(
      "select schematicName from planetSchematics where schematicID=#{schem_id.to_i}")[0][0]
  end
end
