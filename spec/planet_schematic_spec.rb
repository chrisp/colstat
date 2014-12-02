require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe PlanetSchematic do
  subject { PlanetSchematic.new(76, EveDb.new) }

  describe '#new' do
    it 'initializes with an eve db connection' do
      expect(subject.eve_db.class).to eql(EveDb)
    end

    it 'sets the name' do
      expect(subject.name).to eql('Consumer Electronics')
    end
  end

  describe '#name_for_id(schem_id)' do
    it 'returns the schematic name for the id' do
      expect(subject.send(:name_for_id, 127)).to eql('Precious Metals')
    end
  end
end
