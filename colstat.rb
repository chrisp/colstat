require 'bundler/setup'
require 'crack'
require 'httparty'
require 'pp'
require 'yaml'
require 'pry'

dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
keys = YAML.load_file('keys.yml')

class Character
  include HTTParty
  attr_accessor :character_id, :key_id, :vcode, :colonies, :response, :url

  parser(
    Proc.new do |body, format|
      Crack::XML.parse(body)
    end
  )
  
  def initialize(character_id, key_id, vcode)
    self.character_id = character_id
    self.key_id = key_id
    self.vcode = vcode

    raise "missing args" unless [character_id, key_id, vcode].all?

    begin
      self.url = "https://api.eveonline.com/char/PlanetaryColonies.xml.aspx?characterID=#{character_id}&keyID=#{key_id}&vCode=#{vcode}"
      self.response = Character.get(url)

      self.colonies = response["eveapi"]["result"]["rowset"]["row"]
    rescue
      binding.pry
    end
    self
  end
end

characters = []
keys.each do |key|
  characters << Character.new(key['character_id'], key['key_id'], key['vcode'])
end

characters.each do |character|
  puts "Capsuleer id: #{character.character_id}"
  puts "Colonies: #{character.colonies.to_yaml}"
end

