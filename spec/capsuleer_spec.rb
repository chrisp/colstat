require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe Capsuleer do
  describe '#new' do
    it 'should initialize colony data for passed api data' do
      eve_api = EveApi.new(keys[0]['id'], keys[0]['key_id'], keys[0]['vcode'])
      capsuleer = Capsuleer.new(eve_api)
      expect(capsuleer.colonies).to_not be_nil
      expect(capsuleer.colonies).to_not be_empty
    end 
  end
end
