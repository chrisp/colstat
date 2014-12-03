class Report
  attr_reader :capsuleers,
              :planet_schematics,
              :eve_db
              
  def initialize(keys = 'keys.yml')
    @capsuleers = []
    keys = YAML.load_file(keys)

    keys.each do |key|
      api = EveApi.new(key['id'], key['key_id'], key['vcode'])
      @capsuleers << Capsuleer.retreive(api)
    end

    @eve_db = EveDb.new
    @planet_schematics = {}
  end

  # preprocess to get all schems, could lose the duplication
  def collect_data
    capsuleers.each do |capsuleer|
      capsuleer.colonies.each do |colony|

        pins = colony.facilities.map {|p| p['schematicID']}.reject {|pin| pin.to_i == 0}.uniq
        pins.each_with_index do |pin,i|
          self.planet_schematics[pin] = PlanetSchematic.retrieve(pin, eve_db)
        end
      end
    end
  end

  def products_by_colony(options={})
    collect_data # always get all data
    report_text = "" 

    capsuleers.each do |capsuleer|
      next if options.has_key?(:capsuleer) && options[:capsuleer] != capsuleer.name
      report_text += "#{capsuleer.name}\n"
      report_text += "Colony\t\tType\tProducts\n"
      capsuleer.colonies.each do |colony|
        next if options.has_key?(:planet) && options[:planet] != colony.name
        report_text += "#{colony.name}\t#{colony.short_type}\t"

        pins = colony.facilities.map {|p| p['schematicID']}.reject {|pin| pin.to_i == 0}.uniq
        pins.each_with_index do |pin,i|
          report_text += "\t\t\t" if i > 0

          # TODO relate schem to pins/colonies
          planet_schematic = PlanetSchematic.retrieve(pin, eve_db)
          report_text += "#{planet_schematic.name} (#{pin})"

          if !(planet_schematic.inputs.empty? ||
               planet_schematic.inputs.nil?)

            report_text += "\n\t\t\tInputs:\t" +
              planet_schematic.inputs.map do |i|
                str = "#{i.name} (#{i.id})"
                if planet_schematics.has_key?(i.id.to_s)
                  str
                else
                  str.upcase
                end
              end.join(' ') + "\n"
          end

          report_text += "\n"
        end
      end

      report_text +=
"===========================================================================\n"
    end

    report_text
  end
end
