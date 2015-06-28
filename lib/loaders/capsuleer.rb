class Loader::Capsuleer
  attr_reader :keys
  attr_accessor :capsuleers

  def initialize(init_keys = 'keys.yml')
    @keys = YAML.load_file(init_keys)
    @capsuleers = []
  end

  def load
    keys.each do |key|
      api = EveApi.new(
                       key['id'],
                       key['key_id'],
                       key['vcode'])
      self.capsuleers << Entity::Capsuleer.retreive(api)
      print '.'
    end

    capsuleers
  end
end
