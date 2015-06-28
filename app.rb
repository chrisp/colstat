APP_ROOT = File.
  expand_path(File.join(File.dirname(__FILE__)))

require 'bundler/setup'
require 'crack'
require 'httparty'
require 'pp'
require 'yaml'
require 'pry'
require 'sqlite3'
require 'optparse'
require 'active_record'
require 'require_all'

require_all File.join(APP_ROOT, 'lib')
appdir = File.join(APP_ROOT, 'app')
require_all "#{appdir}/maps"
require_all "#{appdir}/resources"
require_all "#{appdir}/entities"

def setup_active_record
  ActiveRecord::Base.logger = Logger.new(File.join(
                                                   APP_ROOT,
                                                   'debug.log'))
  configuration = YAML::load(IO.read(File.join(
                                               APP_ROOT,
                                               'config',
                                               'database.yml')))
  ActiveRecord::Base.
    establish_connection(configuration['development'])
end

def run_report(options)
  report = Report.new

  if options.has_key?(:inputs_only)
    report.inputs_by_colony(options)
  else
    report.products_by_colony(options) +
    report.inputs_and_outputs
  end
end

setup_active_record
