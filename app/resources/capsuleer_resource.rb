class CapsuleerResource
  attr_accessor :id,
                :eve_api,
                :colony_data,
                :response,
                :url,
                :colony_resources,
                :name

  def initialize(new_eve_api)
    self.id = new_eve_api.capsuleer_id
    self.eve_api = new_eve_api

    unless [id, new_eve_api].all?
      raise ArgumentError.new('api data required')
    end

    base_url = "https://api.eveonline.com/char/PlanetaryColonies.xml.aspx"
    self.url = "#{base_url}?characterID=#{id}&keyID=#{eve_api.key_id}" +
      "&vCode=#{eve_api.vcode}"
    self.response = EveApi.get(url)

    self.colony_data = response["eveapi"]["result"]["rowset"]["row"]
    self.colony_resources = []

    if colony_data.is_a?(Array)
      self.name = colony_data[0]['ownerName']
      colony_data.each do |colony|
        colony_resources << ColonyResource.new(colony, eve_api)
      end
    else
      if colony_data
        self.name = colony_data['ownerName']
        colony_resources << ColonyResource.new(colony_data, eve_api)
      end
    end

    self
  end
end
