class PlanetSchematicResource
  attr_accessor :eve_db,
                :inputs,
                :id,
                :name

  def initialize(schem_id, init_eve_db)
    self.eve_db = init_eve_db
    self.name = name_for_id(schem_id)
    self.id = schem_id unless self.name.empty? || self.name.nil?
    self.inputs = inputs_for_id(schem_id)
  end

  private
  def inputs_for_id(schem_id)
    # TODO optimize and/or don't repull
    input_schematics = eve_db.db.execute(
                                   "select planetSchematics.schematicID,typeName from planetSchematicsTypeMap join InvTypes on planetSchematicsTypeMap.typeID=InvTypes.typeID join planetSchematics on planetSchematics.schematicName=typeName where planetSchematicsTypeMap.schematicID=#{schem_id} and isInput=1;")

    input_schematics.collect do |input_schematic|
      PlanetSchematicResource.new(input_schematic[0], eve_db)
    end
  end

  def name_for_id(schem_id)
    eve_db.db.execute(
                      "select schematicName from planetSchematics where schematicID=#{schem_id.to_i}")[0][0]
  end
end
