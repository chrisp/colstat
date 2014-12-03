require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe CapsuleerResource do
  describe '#new' do
    subject { CapsuleerResource.new(eve_api) }
    it 'should initialize colony data for passed api data' do
      expect(subject.colony_resources).to_not be_nil
      expect(subject.colony_resources).to_not be_empty
    end 
  end
end
