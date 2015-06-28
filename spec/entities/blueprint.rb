require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"


describe Entity::Blueprint do
  describe '#new' do
    it 'loads from blueprints.yml' do
      blueprint = Entity::Blueprint.new
      expect(blueprint).to_not be_blank
    end
  end
end
