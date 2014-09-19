#! /usr/bin/env ruby
require 'bundler/setup'
require 'crack'
require 'httparty'
require 'pp'
require 'yaml'
require 'pry'
require "sqlite3"

libdir = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
require "#{libdir}/eve_api"
require "#{libdir}/eve_db"
require "#{libdir}/planet_schematic"
require "#{libdir}/colony"
require "#{libdir}/capsuleer"
require "#{libdir}/report"

def run_report
  report = Report.new
  report.products_by_colony
end

puts run_report
