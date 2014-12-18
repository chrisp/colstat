class Report
  attr_reader :capsuleers,
              :eve_db

  attr_accessor :planet_schematics,
                :planet_inputs,
                :outputs,
                :inputs


  def initialize(keys = 'keys.yml')
    @capsuleers = []
    keys = YAML.load_file(keys)

    keys.each do |key|
      api = EveApi.new(key['id'], key['key_id'], key['vcode'])
      @capsuleers << Entity::Capsuleer.retreive(api)
    end

    @eve_db = EveDb.new
    @planet_schematics = {}
    @planet_inputs = {}
    @outputs = Hash.new(0)
    @inputs = Hash.new(0)
  end

  # preprocess to get all schems, lose the duplication
  def collect_data(options)
    capsuleers.each do |capsuleer|
      self.planet_inputs[capsuleer.name] = {}
      capsuleer.colonies.each do |colony|
        next if options.has_key?(:system) && !colony.name.upcase.include?(options[:system].upcase)
        self.planet_inputs[capsuleer.name][colony.name] = Hash.new(0)

        pins = colony.facilities.map {|p| p['schematicID']}.reject {|pin| pin.to_i == 0}
        pins.each do |pin|
          self.planet_schematics[pin] = Entity::PlanetSchematic.retrieve(pin, eve_db)
          self.outputs[planet_schematics[pin].name] += 1

          planet_schematics[pin].inputs.uniq {|i| i.name}.each do |input|
            self.inputs[input.name] += 1
            self.planet_inputs[capsuleer.name][colony.name][input.name] += 1
          end
        end
      end
    end
  end

  def inputs_by_colony(options={})
    collect_data(options) # always get all data
    report_text = ""

    capsuleers.each do |capsuleer|
      next if options.has_key?(:capsuleer) && options[:capsuleer] != capsuleer.name
      report_text += "#{capsuleer.name}\n"

      capsuleer.colonies.each do |colony|
        next if options.has_key?(:planet) && options[:planet] != colony.name
        next if options.has_key?(:system) && !colony.name.upcase.include?(options[:system].upcase)
        report_text += "#{colony.name}\t#{colony.short_type}\t\n"

        planet_inputs[capsuleer.name][colony.name].each do |name, count|
          report_text += "#{name} [#{count} - #{count*300}]\n"
        end
      end
    end

    report_text
  end

  def products_by_colony(options={})
    collect_data(options) # always get all data
    report_text = ""

    capsuleers.each do |capsuleer|
      next if options.has_key?(:capsuleer) && options[:capsuleer] != capsuleer.name
      report_text += "#{capsuleer.name}\n"
      report_text += "Colony\t\tType\tProducts\n"
      capsuleer.colonies.each do |colony|
        next if options.has_key?(:planet) && options[:planet] != colony.name
        next if options.has_key?(:system) && !colony.name.upcase.include?(options[:system].upcase)
        report_text += "#{colony.name}\t#{colony.short_type}\t"

        pins = colony.facilities.map {|p| p['schematicID']}.reject {|pin| pin.to_i == 0}.uniq
        pins.each_with_index do |pin,i|
          report_text += "\t\t\t" if i > 0

          # TODO relate schem to pins/colonies
          planet_schematic = Entity::PlanetSchematic.retrieve(pin, eve_db)
          report_text += "#{planet_schematic.name} (#{pin})\n"
        end

        unless planet_inputs[capsuleer.name][colony.name].empty?
          report_text += "Inputs:\n"
          planet_inputs[capsuleer.name][colony.name].each do |name, count|
            report_text += "#{name} [#{count} - #{count*40} -  #{count*300}]\n"
          end
          report_text += "\n"
        end
      end

      report_text +=
"===========================================================================\n"
    end

    report_text += "Name\t\t\tInputs:Outputs\n"
    inputs.each do |name, count|
      tabs = 4 - (name.length/4).floor
      if (count/3 > outputs[name])
        report_text += name.upcase
      else
        report_text += name
      end

      tabs.times do
        report_text += "\t"
      end
      report_text +="\t#{count/3}:#{outputs[name]}\n"
    end
    report_text
  end
end
