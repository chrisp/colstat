class EveDb
  attr_reader :db
  def initialize
    dbdir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'db'))
    @db = SQLite3::Database.new(File.join(dbdir, 'eve.db'))
  end
end
