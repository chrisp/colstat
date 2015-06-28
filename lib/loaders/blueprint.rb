class Loader::Blueprint
  attr_reader :names
  attr_accessor :blueprints

  def initialize(init_names = 'names.yml')
    @names = YAML.load_file(init_names)
    @blueprints = []
  end

  def load
    names.each do |name|
      self.blueprints << Entity::Blueprint.retrieve(name)
    end

    blueprints
  end
end
