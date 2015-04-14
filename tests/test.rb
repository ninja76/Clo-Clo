ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative '../app.rb'

include Rack::Test::Methods

def app
  MyApp
end

describe "" do
  it "Get data from stream 2" do
    get '/streams/2'
    last_response.must_be :ok?
  end
  
  it "Update Test Stream 5" do
    get '/api/update?stream_id=5&key=086c322e0f2a&field1=100&field2=200'
    last_response.must_be :ok?
  end

  it "Fetch public stream list" do
    get '/streams'
    last_response.must_be :ok?
  end

end

