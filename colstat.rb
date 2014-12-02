#! /usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), 'app'))

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

puts run_report(options)
