class Capsuleer
  attr_accessor :id, :key_id, :vcode, :colony_data, :response, :url, :colonies

  def initialize(cap_id, new_key_id, new_vcode)
    self.id = cap_id
    self.key_id = new_key_id
    self.vcode = new_vcode

    raise "Capsuleer#initialize: missing args" unless [id, key_id, vcode].all?

    begin
      self.url = "https://api.eveonline.com/char/PlanetaryColonies.xml.aspx?characterID=#{id}&keyID=#{key_id}&vCode=#{vcode}"
      self.response = EveApi.get(url)

      self.colony_data = response["eveapi"]["result"]["rowset"]["row"]
      self.colonies = []

      if colony_data.is_a?(Array)
        colony_data.each do |colony|
          colonies << Colony.new(colony["planetID"], id, key_id, vcode)
        end
      else
        colonies << Colony.new(colony_data["planetID"], id, key_id, vcode)
      end
    rescue Exception => e
      binding.pry
    end
    self
  end
end
