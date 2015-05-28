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
      api = EveApi.new(
                       key['id'],
                       key['key_id'],
                       key['vcode'])
      @capsuleers << Entity::Capsuleer.retreive(api)
      print '.'
    end
    print "\n"

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
        next if options.has_key?(:system) &&
          !colony.name.upcase.include?(options[:system].upcase)
        self.planet_inputs[capsuleer.name][colony.name] = Hash.new(0)

        colony.unique_schematics_by_pin.each do |pin|
          self.planet_schematics[pin] = Entity::PlanetSchematic.retrieve(pin, eve_db)
          self.outputs[planet_schematics[pin].name] += 1
          inputs = planet_schematics[pin].inputs.uniq do |input|
            input.name
          end

          inputs.each do |input|
            self.inputs[input.name] += 1
            self.planet_inputs[capsuleer.name][colony.name][input.name] += 1
          end
        end
      end
    end
  end

  def inputs_for_capsuleer_colony(capsuleer, colony)
    planet_inputs[capsuleer.name][colony.name].map do |name, count|
      "#{name} [#{count*180}:#{count*300}:#{count*600}:#{count*900}]\n"
    end.join
  end

  def inputs_by_colony(options={})
    collect_data(options) # always get all data
    report_text = ""

    capsuleers.each do |capsuleer|
      next if options.has_key?(:capsuleer) &&
        options[:capsuleer] != capsuleer.name
      report_text += "#{capsuleer.name}\n"

      capsuleer.colonies.each do |colony|
        next if options.has_key?(:planet) &&
          options[:planet] != colony.name
        next if options.has_key?(:system) &&
          !colony.name.upcase.include?(options[:system].upcase)
        report_text += "#{colony.name}\t#{colony.short_type}\t\n"

        unless planet_inputs[capsuleer.name][colony.name].empty?
          report_text += inputs_for_capsuleer_colony(capsuleer, colony)
          report_text += "\n"
        end
      end

      report_text += section_break
    end

    report_text
  end

  def sorted_inputs
    inputs.sort do |x,y|
      y[1].to_f/outputs[y[0]].to_f <=> x[1].to_f/outputs[x[0]].to_f
    end
  end

  def section_break
    "===========================================================================\n"
  end

  def inputs_and_outputs
    report_text = "Name\t\t\tInputs:Outputs\n"
    sorted_inputs.each do |name, count|
      tabs = 4 - (name.length/4).floor
      if (count > outputs[name]) # applies to T2 mats
        report_text += name.upcase
      elsif (count > outputs[name]/2) # applies to T3+ mats
        report_text += name.capitalize
      else
        report_text += name.downcase
      end

      tabs.times do
        report_text += "\t"
      end
      report_text +="\t#{count}:#{outputs[name]} #{(count.to_f/outputs[name].to_f).round(2)}\n"
    end
    report_text
  end

  def products_by_colony(options={})
    collect_data(options) # always get all data
    report_text = ""

    capsuleers.each do |capsuleer|
      next if options.has_key?(:capsuleer) &&
        options[:capsuleer] != capsuleer.name
      report_text += "#{capsuleer.name}\n"
      report_text += "Colony\t\tType\tProducts\n"
      capsuleer.colonies.each do |colony|
        next if options.has_key?(:planet) &&
          options[:planet] != colony.name
        next if options.has_key?(:system) &&
          !colony.name.upcase.include?(options[:system].upcase)
        report_text += "#{colony.name}\t#{colony.short_type}\t"

        colony.unique_schematics.each_with_index do |pin,i|
          report_text += "\t\t\t" if i > 0

          # TODO relate schem to pins/colonies
          planet_schematic = Entity::PlanetSchematic.retrieve(pin, eve_db)
          report_text += "#{planet_schematic.name} (#{pin})\n"
        end

        unless planet_inputs[capsuleer.name][colony.name].empty?
          report_text += "Inputs:\n"
          report_text += inputs_for_capsuleer_colony(capsuleer, colony)
          report_text += "\n"
        end
      end

      report_text += section_break
    end

    report_text
  end
end
