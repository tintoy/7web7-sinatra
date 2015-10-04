require_relative 'app'

require 'rspec'
require 'rack/test'

describe 'Bookmarks application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'creates a new bookmark' do
    # First, figure out how many bookmarks we have already
    get '/bookmarks'
    bookmarks = JSON.parse(last_response.body)
    last_size = bookmarks.size

    post '/bookmarks', {
      :url => 'http://www.test.com/',
      :title => 'Test'
    }
    expect(last_response.status).to eq(201) # HTTP 201 = Created
    expect(last_response.body).to match(/\/bookmarks\/\d+/)

    # Follow the link to the created bookmark
    bookmarkByIdUrl = last_response.body
    get bookmarkByIdUrl
    expect(last_response).to be_ok

    #  Verify that we now have one more bookmark
    get "/bookmarks"
    bookmarks = JSON.parse(last_response.body)
    expect(bookmarks.size).to eq(last_size + 1)
  end

  it 'updates an existing bookmark' do
    initialBookmark = {
      :url => 'http://test.com/',
      :title => 'test'
    }

    post '/bookmarks', initialBookmark
    bookmarkByIdUrl = last_response.body

    put bookmarkByIdUrl, {
      :url => initialBookmark[:url], # Shouldn't need to copy this across if it doesn't exist! Fix the Hash.Slice function.
      :title => 'Updated'
    }
    expect(last_response).to be_ok

    get bookmarkByIdUrl
    expect(last_response).to be_ok
    updatedBookmark = JSON.parse(last_response.body)
    puts updatedBookmark

    # Doesn't work if I replace ['url'] with [:url].
    # I'm assuming ':identifier' is some sort of identity-value syntax for use as keys.
    # Perhaps when deserialising from JSON the keys would be strings instead?
    expect(updatedBookmark['url']).to eq(initialBookmark[:url])
    expect(updatedBookmark['title']).to eq('Updated')
  end
end
