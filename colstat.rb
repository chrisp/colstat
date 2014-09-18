#! /usr/bin/env ruby
require 'bundler/setup'
require 'crack'
require 'httparty'
require 'pp'
require 'yaml'
require 'active_model'
require 'pry'

libdir = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require "#{libdir}/eve_api"
require "#{libdir}/colony"
require "#{libdir}/capsuleer"

def run_report
  capsuleers = []
  keys = YAML.load_file('keys.yml')

  keys.each do |key|
    capsuleers << Capsuleer.new(EveApi.new(key['id'], key['key_id'], key['vcode']))
  end

  capsuleers.each do |capsuleer|
    puts "Capsuleer id: #{capsuleer.id}"
    puts "Colony_Data: #{capsuleer.colony_data.to_yaml}"

    capsuleer.colonies.each do |colony|
      puts "Colony #{colony.id}"
      colony.pin_data.each do |pin|
        puts "pin #{pin['typeName']} #{pin['schematicID']} #{pin['expiryTime']}"
      end

      colony.link_data.each do |link|
        puts "link #{link.inspect}"
      end

      colony.route_data.each do |route|
        puts "route #{route['routeID']}"
      end
    end
  end
end

run_report
