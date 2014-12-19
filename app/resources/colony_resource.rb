class ColonyResource
  attr_accessor :id,
                :name,
                :type,
                :eve_api,
                :response,
                :base_url,
                :url,
                :pin_data,
                :link_data,
                :route_data

  def initialize(colony, new_eve_api)
    self.base_url = "https://api.eveonline.com"
    self.eve_api = new_eve_api
    init_colony_data(colony)
    init_pin_data
    init_link_data
    init_route_data
  end

  private
  def init_colony_data(colony)
    self.id = colony['planetID']
    self.name = colony['planetName']
    self.type = colony['planetTypeName'].match(/\((.*)\)/)[1]
  end

  def init_pin_data
    path = "char/PlanetaryPins.xml.aspx"
    self.url = "#{base_url}/#{path}?" +
      "characterID=#{eve_api.capsuleer_id}" +
      "&keyID=#{eve_api.key_id}" +
      "&vCode=#{eve_api.vcode}&planetID=#{id}"
    self.response = EveApi.get(url)
    self.pin_data = response["eveapi"]["result"]["rowset"]["row"]
  end

  def init_link_data
    path = 'char/PlanetaryLinks.xml.aspx'
    self.url = "#{base_url}/#{path}?" +
      "characterID=#{eve_api.capsuleer_id}" +
      "&keyID=#{eve_api.key_id}" +
      "&vCode=#{eve_api.vcode}&planetID=#{id}"
    self.response = EveApi.get(url)
    self.link_data = response["eveapi"]["result"]["rowset"]["row"]
  end

  def init_route_data
    path = 'char/PlanetaryRoutes.xml.aspx'
    self.url = "#{base_url}/#{path}?" +
      "characterID=#{eve_api.capsuleer_id}" +
      "&keyID=#{eve_api.key_id}" +
      "&vCode=#{eve_api.vcode}&planetID=#{id}"
    self.response = EveApi.get(url)
    self.route_data = response["eveapi"]["result"]["rowset"]["row"]
  end
end
