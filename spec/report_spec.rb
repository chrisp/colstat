require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe Report do
  subject { Report.new('keys.yml.example') }

  describe '#new' do
    it 'should initialize data for all capsuleers' do
      expect(subject.capsuleers).
        to_not be_nil
    end
  end

  describe '#inputs_by_colony' do
    it 'should show all inputs required by colony' do
      result = subject.inputs_by_colony
      expect(result).
        to(eql("Bobby McBlueShoot\nColony          Type       Products       \nNew Eden XII\tOceanic\t\n     *180:*300:*600: *900\n      180: 300: 600:  900  Toxic Metals                  \n      180: 300: 600:  900  Chiral Structures             \n\n===========================================================================\n"))
    end
  end

  describe '#products_by_colony' do
    it 'should show all products being produced for each colony' do
      result = subject.products_by_colony
      expect(result).
        to(eql("Bobby McBlueShoot\nColony          Type       Products       \nNew Eden I      Plasma     Precious Metals\nNew Eden III    Lava       Toxic Metals\nNew Eden IX     Gas        Oxygen    \nNew Eden X      Storm      Reactive Metals\nNew Eden XII    Oceanic    Bacteria  \n                           Consumer Electronics\nInputs:\n     *180:*300:*600: *900\n      180: 300: 600:  900  Toxic Metals                  \n      180: 300: 600:  900  Chiral Structures             \n\n===========================================================================\n"))
    end
  end
end
