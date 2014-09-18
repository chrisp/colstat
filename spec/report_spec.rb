require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe Report do
  subject { Report.new('keys.yml.example') }

  describe '#new' do
    it 'should initialize data for all capsuleers' do
      expect(subject.capsuleers).to_not be_nil
    end
  end

  describe '#products_by_colony' do
    it 'should show all products being produced for each colony' do
      result = subject.products_by_colony
      expect(result).to_not be_nil
      expect(result).to_not be_empty
    end
  end
end
