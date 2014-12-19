class Entity::Colony
  attr_accessor :id,
                :name,
                :type,
                :capsuleer,
                :facilities

  private
  attr_accessor :resource,
                :mapper

  public
  def initialize(init={})
    if init.has_key?(:resource)
      self.resource = init[:resource]
    end

    if init.has_key?(:mapper)
      self.mapper = init[:mapper]
    end

    if init.has_key?(:capsuleer)
      self.capsuleer = init[:capsuleer]
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
    self.type = resource.type
    self.facilities = resource.pin_data
  end

  def init_from_mapper
    self.id = mapper.resource_id
    self.name = mapper.name
    self.type = mapper.colony_type
    self.capsuleer = mapper.capsuleer
    self.facilities = JSON::parse(mapper.facilities)
  end

  def save_map
    self.mapper = ::Colony.new(
                               resource_id: id,
                               capsuleer: capsuleer.mapper,
                               name: name,
                               colony_type: type,
                               facilities: facilities.to_json)
    mapper.save!
  end

  def short_type
    type.sub("Temperate", "Temp")
  end

  def self.retrieve(api)
    new(ColonyResource.new(api))
  end
end
