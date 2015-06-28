class Entity::Blueprint
  attr_accessor :id,
                :name

  def self.retrieve(name)
    blueprint = new
    blueprint.name = name
    blueprint
  end
end
