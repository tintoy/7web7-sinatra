require 'data_mapper'
require 'dm-serializer'
require 'sinatra'

require_relative 'bookmark'
require_relative 'database'
require_relative 'utils'

# Get all bookmarks
get '/bookmarks' do
  bookmarks = get_all_bookmarks

  content_type :json
  bookmarks.to_json
end

# Get a bookmark by Id
get '/bookmarks/:id' do
  id = params[:id]
  bookmark = Bookmark.get(id)
  unless bookmark == nil
    content_type :json
    bookmark.to_json
  else
    [404, "No bookmark found with Id #{id}"]
  end
end

# Create a bookmark
post '/bookmarks' do
  bookmark = Bookmark.create(
    params.slice 'url', 'title'
  )

  # Created
  [201, "/bookmarks/#{bookmark['id']}"]
end

# Update a bookmark by Id
put '/bookmarks/:id' do
  id = params[:id]
  bookmark = Bookmark.get(id)
  unless bookmark == nil
    bookmark.update(
      params.slice 'url', 'title'
    )

    content_type :json
    bookmark.to_json
  else
    [404, "No bookmark found with Id #{id}"]
  end
end

# Delete a bookmark by Id
delete '/bookmarks/:id' do
  id = params[:id]
  bookmark = Bookmark.get(id)
  unless bookmark == nil
    bookmark.destroy

    200 # OK
  else
    [404, "No bookmark found with Id #{id}"]
  end
end
