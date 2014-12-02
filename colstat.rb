#! /usr/bin/env ruby
require 'bundler/setup'
require 'crack'
require 'httparty'
require 'pp'
require 'yaml'
require 'pry'
require "sqlite3"
require "optparse"

libdir = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require "#{libdir}/eve_api"
require "#{libdir}/eve_db"
require "#{libdir}/planet_schematic"
require "#{libdir}/colony"
require "#{libdir}/capsuleer"
require "#{libdir}/report"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: colstat.rb [options]"
  opts.on('-p',
          '--planet PLANET',
          'report for planet') do |v|
    options[:planet] = v
  end

  opts.on('-c',
          '--capsuleer CAPSULEER',
          'report for capsuleer') do |v|
    options[:capsuleer] = v
  end
end.parse!

def run_report(options)
  report = Report.new
  report.products_by_colony(options)
end

puts run_report(options)
