# encoding: utf-8
  get '/index' do
    slim :main
  end

  get '/' do
    redirect "/index"
  end

  get '/login' do
    slim :login
  end
