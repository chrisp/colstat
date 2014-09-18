require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe Capsuleer do
  describe '#new' do
    it 'should initialize colony data for passed api data' do
      keys = YAML.load_file('keys.yml.example')

      response = File.read('spec/xml/planetary_colonies.xml')
      base_path = 'https://api.eveonline.com/char/PlanetaryColonies.xml.aspx'
      stub_request(:get, 
        "#{base_path}?characterID=#{keys[0]['id']}&keyID=#{keys[0]['key_id']}" + 
        "&vCode=#{keys[0]['vcode']}").
          to_return(
            :status => 200, 
            :body => response, 
            :headers => {'Content-Type' => 'application/xml; charset=utf-8'})

      eve_api = EveApi.new(keys[0]['id'], keys[0]['key_id'], keys[0]['vcode'])
      capsuleer = Capsuleer.new(eve_api)
      puts capsuleer.colonies.inspect
    end 
  end
end
