class Colony
  attr_accessor :id, :cap_id, :key_id, :vcode, :response, :url, :pin_data, :link_data, :route_data

  def initialize(planet_id, new_cap_id, new_key_id, new_vcode)
    self.id = planet_id
    self.key_id = new_key_id
    self.vcode = new_vcode
    self.cap_id = new_cap_id

    begin
      self.url = "https://api.eveonline.com/char/PlanetaryPins.xml.aspx?characterID=#{cap_id}&keyID=#{key_id}&vCode=#{vcode}&planetID=#{id}"
      self.response = EveApi.get(url)
      self.pin_data = response["eveapi"]["result"]["rowset"]["row"]

      self.url = "https://api.eveonline.com/char/PlanetaryLinks.xml.aspx?characterID=#{cap_id}&keyID=#{key_id}&vCode=#{vcode}&planetID=#{id}"
      self.response = EveApi.get(url)
      self.link_data = response["eveapi"]["result"]["rowset"]["row"]

      self.url = "https://api.eveonline.com/char/PlanetaryRoutes.xml.aspx?characterID=#{cap_id}&keyID=#{key_id}&vCode=#{vcode}&planetID=#{id}"
      self.response = EveApi.get(url)
      self.route_data = response["eveapi"]["result"]["rowset"]["row"]
    rescue
      binding.pry
    end
  end
end
