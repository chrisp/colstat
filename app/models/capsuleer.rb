class Capsuleer
  attr_accessor :id, :name

  private
  attr_accessor :resource, :map

  def initialize(init_resource)
    self.resource = init_resource
  end

  def colonies
    resource.colonies
  end

  def id
    resource.id
  end
  
  def name
    resource.name
  end

  def self.retreive(api)
    new(CapsuleerResource.new(api))
  end
end
