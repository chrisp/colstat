libdir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'crack'
require 'httparty'
require "#{libdir}/eve_api"
require "#{libdir}/capsuleer"
require "#{libdir}/colony"
require 'pry'
require 'webmock/rspec'

# class EveApi
#   def self.get(url)
#     puts url
#   end
# end
