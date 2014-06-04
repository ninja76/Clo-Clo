# encoding: utf-8
  get '/index' do
    erb :main
  end

  get '/' do
    redirect "/index"
  end

  get '/login' do
    erb :login
  end
