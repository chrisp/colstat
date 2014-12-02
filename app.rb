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
require "#{libdir}/planet_schematic"
require "#{libdir}/colony"
require "#{libdir}/capsuleer"
require "#{libdir}/report"

appdir = File.expand_path(File.join(File.dirname(__FILE__), 'app'))
require "#{appdir}/maps/capsuleer_map"

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
