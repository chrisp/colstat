require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe Capsuleer do
  describe '#new' do
    it 'should initialize colony data for passed api data' do
      capsuleer = Capsuleer.new(eve_api)
      expect(capsuleer.colonies).to_not be_nil
      expect(capsuleer.colonies).to_not be_empty
    end 
  end
end
