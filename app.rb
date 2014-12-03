APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

require 'bundler/setup'
require 'crack'
require 'httparty'
require 'pp'
require 'yaml'
require 'pry'
require 'sqlite3'
require 'optparse'
require 'active_record'

libdir = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require "#{libdir}/eve_api"
require "#{libdir}/eve_db"
require "#{libdir}/report"

appdir = File.expand_path(File.join(File.dirname(__FILE__), 'app'))
require "#{appdir}/maps/capsuleer_map"
require "#{appdir}/resources/capsuleer_resource"
require "#{appdir}/resources/colony_resource"
require "#{appdir}/resources/planet_schematic_resource"
require "#{appdir}/models/capsuleer"
require "#{appdir}/models/colony"
require "#{appdir}/models/planet_schematic"

def setup_active_record
  ActiveRecord::Base.logger = Logger.new(File.join(APP_ROOT, 'debug.log'))
  configuration = YAML::load(IO.read(File.join(APP_ROOT, 'config', 'database.yml')))
  ActiveRecord::Base.establish_connection(configuration['development'])
end

def run_report(options)
  report = Report.new
  report.products_by_colony(options)
end

setup_active_record
