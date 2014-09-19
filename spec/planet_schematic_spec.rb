require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe PlanetSchematic do
  subject { PlanetSchematic.new(EveDb.new) }

  describe '#new' do
    it 'should initialize with an eve db connection' do
      expect(subject.eve_db.class).to eql(EveDb)
    end
  end

  describe '#name_for_id(schem_id)' do
    it 'should return the schematic name for the id' do
      expect(subject.name_for_id(127)).to eql('Precious Metals')
    end
  end
end
