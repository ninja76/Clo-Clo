# encoding: utf-8
##
##
##
  get '/index' do
    @isloggedin = isLoggedIn(session)
    slim :main
  end

##
##
##
  get '/' do
    redirect "/index"
  end

##
##
##
  get '/login' do
    if isLoggedIn(session)
      redirect '/dashboard'
    end
    redirect '/auth/twitter'
  end

##
##
##
  get '/logout' do
    session.clear
    puts "clearing session #{session.inspect}"
    redirect '/'
  end

##
##  
##
  get '/register' do
    slim :register
  end
