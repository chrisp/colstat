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

  opts.on('-i',
          '--inputs-only',
          'only display required inputs') do |v|
    options[:inputs_only] = v
  end

  opts.on('-s',
          '--system SYSTEM',
          'report for system') do |v|
    options[:system] = v
  end

  opts.on('-c',
          '--capsuleer CAPSULEER',
          'report for capsuleer') do |v|
    options[:capsuleer] = v
  end
end.parse!

puts run_report(options)
