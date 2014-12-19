class Entity::Capsuleer
  attr_accessor :id,
                :key_id,
                :name,
                :colonies

  attr_accessor :resource,
                :mapper

  def initialize(init={})
    if init.has_key?(:resource)
      self.resource = init[:resource]
    end

    if init.has_key?(:mapper)
      self.mapper = init[:mapper]
    end

    if mapper.blank?
      init_from_resource
      save_map
    else
      init_from_mapper
    end
  end

  def init_from_resource
    self.id = resource.id
    self.name = resource.name
  end

  def init_from_mapper
    self.id = mapper.resource_id
    self.name = mapper.name

    self.colonies = mapper.colonies.map do |colony_map|
      Entity::Colony.new(mapper: colony_map)
    end
  end

  def save_map
    self.mapper = ::Capsuleer.
      new(
          resource_id: id,
          name: name)
    mapper.save!

    self.colonies = resource.colony_resources.map do |colony_resource|
      Entity::Colony.new(resource: colony_resource, capsuleer: self)
    end
  end

  def self.retreive(api)
    capsuleer_map = ::Capsuleer.where(resource_id: api.capsuleer_id).first

    if capsuleer_map.blank?
      new(resource: CapsuleerResource.new(api))
    else
      new(mapper: capsuleer_map)
    end
  end
end
