class CapsuleerResource
  attr_accessor :id,
                :eve_api,
                :colony_data,
                :response,
                :base_url,
                :url,
                :colony_resources,
                :name

  def initialize(new_eve_api)
    self.id = new_eve_api.capsuleer_id
    self.eve_api = new_eve_api

    unless [id, new_eve_api].all?
      raise ArgumentError.
        new('api data required')
    end

    api_url = "https://api.eveonline.com"
    self.base_url = api_url +
      "/char/PlanetaryColonies.xml.aspx"
    init_colony_data
    map_colonies
  end

  private
  def init_colony_data
    self.url = "#{base_url}?characterID=#{id}" +
      "&keyID=#{eve_api.key_id}" +
      "&vCode=#{eve_api.vcode}"
    self.response = EveApi.
      get(url)["eveapi"]

    self.colony_data =
      response["result"]["rowset"]["row"]
    self.colony_resources = []
  end

  def map_colonies
    if colony_data.is_a?(Array)
      self.name = colony_data[0]['ownerName']
      colony_data.each do |colony|
        colony_resources <<
          ColonyResource.new(colony, eve_api)
      end
    else
      if colony_data
        self.name = colony_data['ownerName']
        colony_resources <<
          ColonyResource.new(colony_data, eve_api)
      end
    end
  end
end
