class Entity::Capsuleer
  attr_accessor :id,
                :name,
                :colonies

  private
  attr_accessor :resource,
                :mapper

  def initialize(init_resource)
    self.resource = init_resource
    self.id = resource.id
    self.name = resource.name
    map_colonies
    save_map
  end

  def map_colonies
    self.colonies = resource.colony_resources.map do |colony_resource|
      Entity::Colony.new(colony_resource)
    end
  end

  def save_map
    self.mapper = CapsuleerMap.new(
                               resource_id: id,
                               name: name)
    mapper.save!
  end

  def self.retreive(api)
    new(CapsuleerResource.new(api))
  end
end
