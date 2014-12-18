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

  describe '#inputs_by_colony' do
    xit 'should show all inputs required by colony' do
      result = subject.inputs_by_colony
    end
  end

  describe '#products_by_colony' do
    it 'should show all products being produced for each colony' do
      result = subject.products_by_colony
    #  expect(result).to_not be_nil
    #  expect(result).to_not be_empty
    #  expect(result).to eql "Bobby McBlueShoot\nColony\t\tType\tProducts\nNew Eden I\tPlasma\tPrecious Metals (127)\nNew Eden III\tLava\tToxic Metals (128)\nNew Eden IX\tGas\tOxygen (124)\nNew Eden X\tStorm\tReactive Metals (126)\nNew Eden XII\tOceanic\tBacteria (131)\n\t\t\tConsumer Electronics (76)\n\t\t\tInputs:\tToxic Metals (128) CHIRAL STRUCTURES (129)\n\n===========================================================================\n"
      puts result
    end
  end
end
