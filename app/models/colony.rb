class Colony
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
  end  

  def short_type
    type.sub("Temperate", "Temp")
  end

  def self.retrieve(api)
    new(ColonyResource.new(api))
  end
end
