# encoding: utf-8
  get '/index' do
    geolookup("74.115.251.126")
    erb :main
  end

  get '/' do
    redirect "/index"
  end

  get '/login' do
    erb :login
  end
