class Entity::Colony
  attr_accessor :id,
                :name,
                :type,
                :facilities

  private
  attr_accessor :resource,
                :mapper

  public
  def initialize(init_resource)
    self.resource = init_resource
    self.id = resource.id
    self.name = resource.name
    self.type = resource.type
    self.facilities = resource.pin_data
    save_map
  end

  def save_map
    self.mapper = ColonyMap.new(
                                resource_id: id,
                                name: name)
    mapper.save!
  end

  def short_type
    type.sub("Temperate", "Temp")
  end

  def self.retrieve(api)
    new(ColonyResource.new(api))
  end
end
