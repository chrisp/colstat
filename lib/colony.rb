class Colony
  attr_accessor :id, 
                :eve_api, 
                :response, 
                :url, 
                :pin_data, 
                :link_data, 
                :route_data

  def initialize(planet_id, new_eve_api)
    self.id = planet_id
    self.eve_api = new_eve_api

    base_url = "https://api.eveonline.com"
    path = "char/PlanetaryPins.xml.aspx"
    self.url = "#{base_url}/#{path}?characterID=#{eve_api.capsuleer_id}" + 
      "&keyID=#{eve_api.key_id}&vCode=#{eve_api.vcode}&planetID=#{id}"
    self.response = EveApi.get(url)
    self.pin_data = response["eveapi"]["result"]["rowset"]["row"]

    path = 'char/PlanetaryLinks.xml.aspx'
    self.url = "#{base_url}/#{path}?characterID=#{eve_api.capsuleer_id}" + 
      "&keyID=#{eve_api.key_id}&vCode=#{eve_api.vcode}&planetID=#{id}"
    self.response = EveApi.get(url)
    self.link_data = response["eveapi"]["result"]["rowset"]["row"]

    path = 'char/PlanetaryRoutes.xml.aspx'
    self.url = "#{base_url}/#{path}?characterID=#{eve_api.capsuleer_id}" +
      "&keyID=#{eve_api.key_id}&vCode=#{eve_api.vcode}&planetID=#{id}"
    self.response = EveApi.get(url)
    self.route_data = response["eveapi"]["result"]["rowset"]["row"]
  end
end
