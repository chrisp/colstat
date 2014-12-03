class PlanetSchematic
  attr_accessor :id,
                :name,
                :inputs

  private
  attr_accessor :resource, 
                :mapper

  def initialize(init_resource)
    self.resource = init_resource
    self.id = resource.id
    self.name = resource.name
    self.inputs = resource.inputs
  end

  def self.retrieve(pin, eve_db)
    new(PlanetSchematicResource.new(pin, eve_db))
  end
end
