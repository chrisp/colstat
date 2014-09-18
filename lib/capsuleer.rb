class Capsuleer
  attr_accessor :id, :eve_api, :colony_data, :response, :url, :colonies

  def initialize(new_eve_api)
    self.id = new_eve_api.capsuleer_id
    self.eve_api = new_eve_api

    unless [id, new_eve_api].all?
      raise ArgumentError.new('api data required')  
    end

    base_path = "https://api.eveonline.com/char/PlanetaryColonies.xml.aspx"
    self.url = "#{base_path}?characterID=#{id}&keyID=#{eve_api.key_id}" + 
      "&vCode=#{eve_api.vcode}"
    self.response = EveApi.get(url)

    self.colony_data = response["eveapi"]["result"]["rowset"]["row"]
    self.colonies = []

    if colony_data.is_a?(Array)
      colony_data.each do |colony|
        colonies << Colony.new(colony["planetID"], id, eve_api.key_id, eve_api.vcode)
      end
    else
      colonies << Colony.new(colony_data["planetID"], id, eve_api.key_id, eve_api.vcode)
    end

    self
  end
end
