  get '/dashboard' do
    puts session[:user_id]
    if session[:user_id]
      @streams = database[:streams].filter(:account_uid => session[:user_id])
      puts @streams.inspect 
      slim :dashboard
    else
      redirect '/login'
    end
  end

