class EveDb
  attr_reader :db
  def initialize
    dbdir = File.join(APP_ROOT, 'db')
    @db = SQLite3::Database.
      new(File.join(dbdir, 'eve.db'))
  end
end
