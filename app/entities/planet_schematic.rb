class Entity::PlanetSchematic
  attr_accessor :id,
                :name,
                :inputs

  private
  attr_accessor :resource,
                :mapper

  public
  def initialize(init_resource)
    self.resource = init_resource
    self.id = resource.id
    self.name = resource.name
    self.inputs = resource.inputs
    save_map
  end

  def save_map
    self.mapper = ::PlanetSchematic.
      new(
          resource_id: id,
          name: name)
    mapper.save!
  end

  def self.retrieve(pin, eve_db)
    new(PlanetSchematicResource.
        new(pin, eve_db))
  end
end
