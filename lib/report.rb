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

  # preprocess to get all schems, always use all colonies
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

  def inputs_by_colony_for_capsuleer_colony(capsuleer, colony)
    report_text = "#{colony.name}\t#{colony.short_type}\t\n"
    report_text += inputs_for_capsuleer_colony(capsuleer, colony)
    report_text += "\n"
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
      report_text +=
        "\t#{count}:#{outputs[name]} " +
        "#{(count.to_f/outputs[name].to_f).round(2)}\n"
    end
    report_text
  end

  def planet_schematic(pin)
    planet_schematic = Entity::PlanetSchematic.
      retrieve(pin, eve_db)
    "#{planet_schematic.name} (#{pin})\n"
  end

  def products_for_capsuleer_colony(capsuleer, colony)
    report_text = "#{colony.name}\t#{colony.short_type}\t"

    colony.unique_schematics.each_with_index do |pin,i|
      report_text += "\t\t\t" if i > 0
      report_text += planet_schematic(pin)
    end

    unless planet_inputs[capsuleer.name][colony.name].empty?
      report_text += "Inputs:\n"
      report_text +=
        inputs_for_capsuleer_colony(capsuleer, colony)
      report_text += "\n"
    end

    report_text
  end

  def capsuleer_colonies(options)
    report_text = ""

    capsuleers.each do |capsuleer|
      next if options.has_key?(:capsuleer) &&
        options[:capsuleer] != capsuleer.name

      report_text += "#{capsuleer.name}\n"
      unless options.has_key?(:inputs_only)
        report_text += "Colony\t\tType\tProducts\n"
      end

      capsuleer.colonies.each do |colony|
        next if options.has_key?(:planet) &&
          options[:planet] != colony.name
        next if options.has_key?(:system) &&
          !colony.name.upcase.include?(options[:system].upcase)

        result = yield(capsuleer, colony)
        report_text += result unless result.blank?
      end

      report_text += section_break
    end

    report_text
  end


  def inputs_by_colony(options={})
    collect_data(options)

    capsuleer_colonies(options) do |capsuleer, colony|
      unless planet_inputs[capsuleer.name][colony.name].empty?
        inputs_by_colony_for_capsuleer_colony(capsuleer, colony)
      end
    end
  end

  def products_by_colony(options={})
    collect_data(options)

    capsuleer_colonies(options) do |capsuleer, colony|
      products_for_capsuleer_colony(capsuleer, colony)
    end
  end
end
