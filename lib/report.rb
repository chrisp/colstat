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
    report_text = "" 
    capsuleers.each do |capsuleer|
      report_text += "#{capsuleer.name}\n"
      report_text += "Colony\t\tProducts\n"
      capsuleer.colonies.each do |colony|
        report_text += "#{colony.name}\t"

        pins = colony.pin_data.map {|p| p['schematicID']}.reject {|pin| pin.to_i == 0}.uniq
        pins.each { |pin| report_text += "#{pin}\t" }
        
        report_text += "\n"
      end

      report_text += "============================================\n"
    end

    report_text
  end
end
