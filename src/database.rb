require 'data_mapper'

DataMapper::setup(
  :default,
  "sqlite3://#{Dir.pwd}/bookmarks.db"
)
DataMapper.finalize.auto_upgrade!
