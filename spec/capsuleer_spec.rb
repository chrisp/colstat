require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe Capsuleer do
  describe '#new' do
    it 'should initialize colony data for passed api data' do
      keys = YAML.load_file('keys.yml.example')

      response = File.read('spec/xml/planetary_colonies.xml')
      base_url = 'https://api.eveonline.com'
      path = 'char/PlanetaryColonies.xml.aspx'
      stub_request(:get, 
        "#{base_url}/#{path}?characterID=#{keys[0]['id']}&keyID=#{keys[0]['key_id']}" + 
        "&vCode=#{keys[0]['vcode']}").
          to_return(
            :status => 200, 
            :body => response, 
            :headers => {'Content-Type' => 'application/xml; charset=utf-8'})


      # TODO need at least 1 per pin/link/route
      response = File.read('spec/xml/pins95255214.xml')

      ['95255214', '95255216', '95255225', '95255229', '95255238'].each do |col_id|
        path = 'char/PlanetaryPins.xml.aspx'
        stub_request(:get, "#{base_url}/#{path}?characterID=#{keys[0]['id']}" + 
          "&keyID=#{keys[0]['key_id']}&planetID=#{col_id}&vCode=#{keys[0]['vcode']}").
            to_return(
              :status => 200, 
              :body => response, 
              :headers => {'Content-Type' => 'application/xml; charset=utf-8'})

        path = 'char/PlanetaryLinks.xml.aspx'
        stub_request(:get, "#{base_url}/#{path}?characterID=#{keys[0]['id']}" + 
          "&keyID=#{keys[0]['key_id']}&planetID=#{col_id}&vCode=#{keys[0]['vcode']}").
            to_return(
              :status => 200, 
              :body => response, 
              :headers => {'Content-Type' => 'application/xml; charset=utf-8'})

        path = 'char/PlanetaryRoutes.xml.aspx'
        stub_request(:get, "#{base_url}/#{path}?characterID=#{keys[0]['id']}" + 
          "&keyID=#{keys[0]['key_id']}&planetID=#{col_id}&vCode=#{keys[0]['vcode']}").
            to_return(
              :status => 200, 
              :body => response, 
              :headers => {'Content-Type' => 'application/xml; charset=utf-8'})
      end

      eve_api = EveApi.new(keys[0]['id'], keys[0]['key_id'], keys[0]['vcode'])
      capsuleer = Capsuleer.new(eve_api)
      puts capsuleer.colonies.inspect
    end 
  end
end
