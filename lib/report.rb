class Report
  attr_reader :capsuleers

  def initialize(keys = 'keys.yml')
    @capsuleers = []
    keys = YAML.load_file(keys)

    keys.each do |key|
      @capsuleers << Capsuleer.new(EveApi.new(key['id'], key['key_id'], key['vcode']))
    end
  end

  def products_by_colony
    report_text = "Capsuleer\tColony\t\tProduct\n"
    capsuleers.each do |capsuleer|
      capsuleer.colonies.each do |colony|
        colony.pin_data.each do |pin|
          report_text += "#{capsuleer.id}\t#{colony.id}\t#{pin['schematicID']}\n"
        end
      end
    end

    report_text
  end
end
