class Report
  attr_reader :capsuleers,
              :eve_db

  attr_accessor :planet_schematics,
                :planet_inputs,
                :outputs,
                :inputs

  def initialize(keys = 'keys.yml', blueprints = 'blueprints.yml')
    @capsuleers = Loader::Capsuleer.new(keys).load
    @blueprints = Loader::Blueprint.new(blueprints).load
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
    sprintf("%25s\n", "*180:*300:*600: *900") +
    planet_inputs[capsuleer.name][colony.name].map do |name, count|
      sprintf("%25s  %-30s\n",
              sprintf("%4s:%4s:%4s:%5s", count*180, count*300,count*600, count*900),
              name)
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

  def sorted_outputs
    outputs.sort do |x,y|
      [inputs[y[0]].to_f/y[1].to_f, x[0]] <=> [inputs[x[0]].to_f/x[1].to_f, y[0]]
    end
  end

  def section_break
    "===========================================================================\n"
  end

  def select_case_for(name)
    if (inputs[name] > outputs[name]) # applies to T2 mats
      name.upcase
    elsif (inputs[name] > outputs[name]/2) # applies to T3+ mats
      name.capitalize
    else
      name.downcase
    end
  end

  def deficiency_multiple_for(name)
    @deficiency_of ||= {}
    @deficiency_of[name] ||=
      (inputs[name].to_f/outputs[name].to_f).round(2)
  end

  def colonies_needed_for(name)
    if deficiency_multiple_for(name) > 1.4
      (inputs[name].to_i - outputs[name].to_i) / 9
    else
      nil
    end
  end

  def inputs_and_outputs
    report_text = sprintf("%-25s %-15s %-10s %15s\n",
                          'Name',
                          'Inputs:Outputs',
                          'Multiple',
                          "Colonies Needed")

    sorted_outputs.each do |name, output_count|
      report_text +=
        sprintf("%-25s %-15s %-10s %-15s\n",
                select_case_for(name),
                "#{inputs[name]}:#{outputs[name]}",
                deficiency_multiple_for(name).to_s,
                colonies_needed_for(name).to_s)
    end

    report_text
  end

  def planet_schematic(pin)
    Entity::PlanetSchematic.retrieve(pin, eve_db).name
  end

  def products_for_capsuleer_colony(capsuleer, colony)
    report_text = ''

    if colony.unique_schematics.blank?
      report_text += sprintf("%-15s %-10s %-10s\n",
                             colony.name,
                             colony.short_type,
                             '')
    end

    colony.unique_schematics.each_with_index do |pin, i|
      if i == 0
        pin = colony.unique_schematics.first
        report_text += sprintf("%-15s %-10s %-10s\n",
                               colony.name,
                               colony.short_type,
                               planet_schematic(pin))
      else
        report_text += sprintf("%-15s %-10s %-10s\n",
                               '', '', planet_schematic(pin))
      end
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
        report_text += sprintf("%-15s %-10s %-15s\n",
                               'Colony',
                               'Type',
                               'Products')
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
