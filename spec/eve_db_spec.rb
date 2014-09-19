require 'rspec'
specdir = File.expand_path(File.dirname(__FILE__))
require "#{specdir}/spec_helper"

describe EveDb do
  subject { EveDb.new }
  describe '#new' do
    it 'should initialize a sqlite3 db client' do
      expect(subject.db.class).to eql(SQLite3::Database)
    end
  end
end
