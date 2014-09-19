libdir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
specdir = File.expand_path(File.dirname(__FILE__))
require 'crack'
require 'httparty'
require 'sqlite3'
require "#{libdir}/eve_api"
require "#{libdir}/eve_db"
require "#{libdir}/planet_schematic"
require "#{libdir}/capsuleer"
require "#{libdir}/colony"
require "#{libdir}/report"
require 'pry'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    @keys = YAML.load_file('keys.yml.example')
    def keys; @keys; end
    @eve_api = EveApi.new(keys[0]['id'], keys[0]['key_id'], keys[0]['vcode'])
    def eve_api; @eve_api; end

    
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


    ['95255214', '95255216', '95255225', '95255229', '95255238'].each do |col_id|
      response = File.read("spec/xml/pins#{col_id}.xml")
      path = 'char/PlanetaryPins.xml.aspx'
      stub_request(:get, "#{base_url}/#{path}?characterID=#{keys[0]['id']}" + 
                   "&keyID=#{keys[0]['key_id']}&planetID=#{col_id}&vCode=#{keys[0]['vcode']}").
        to_return(
                  :status => 200, 
                  :body => response, 
                  :headers => {'Content-Type' => 'application/xml; charset=utf-8'})

      response = File.read("spec/xml/links#{col_id}.xml")
      path = 'char/PlanetaryLinks.xml.aspx'
      stub_request(:get, "#{base_url}/#{path}?characterID=#{keys[0]['id']}" + 
                   "&keyID=#{keys[0]['key_id']}&planetID=#{col_id}&vCode=#{keys[0]['vcode']}").
        to_return(
                  :status => 200, 
                  :body => response, 
                  :headers => {'Content-Type' => 'application/xml; charset=utf-8'})

      response = File.read("spec/xml/routes#{col_id}.xml")
      path = 'char/PlanetaryRoutes.xml.aspx'
      stub_request(:get, "#{base_url}/#{path}?characterID=#{keys[0]['id']}" + 
                   "&keyID=#{keys[0]['key_id']}&planetID=#{col_id}&vCode=#{keys[0]['vcode']}").
        to_return(
                  :status => 200, 
                  :body => response, 
                  :headers => {'Content-Type' => 'application/xml; charset=utf-8'})

    end
  end
end
