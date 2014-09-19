class Report
  attr_reader :capsuleers,
              :planet_schematic
              
  def initialize(keys = 'keys.yml')
    @capsuleers = []
    keys = YAML.load_file(keys)

    keys.each do |key|
      @capsuleers << Capsuleer.new(EveApi.new(key['id'], key['key_id'], key['vcode']))
    end

    @planet_schematic = PlanetSchematic.new(EveDb.new)
  end

  def products_by_colony
    report_text = "" 
    capsuleers.each do |capsuleer|
      report_text += "#{capsuleer.name}\n"
      report_text += "Colony\t\tType\tProducts\n"
      capsuleer.colonies.each do |colony|

        report_text += "#{colony.name}\t#{colony.short_type}\t"

        pins = colony.pin_data.map {|p| p['schematicID']}.reject {|pin| pin.to_i == 0}.uniq
        pins.each_with_index do |pin,i| 
          report_text += "\t\t\t" if i > 0

          report_text += "#{planet_schematic.name_for_id(pin)}\n" 
        end
      end

      report_text += "============================================\n"
    end

    report_text
  end
end
