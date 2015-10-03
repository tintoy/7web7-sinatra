require 'data_mapper'

class Bookmark
  include DataMapper::Resource

  property :id, Serial
  property :url, String
  property :title, String
end

def get_all_bookmarks
  Bookmark.all(:order => :title)
end
