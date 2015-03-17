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

  get '/streams' do
  @streams = database[:streams].filter(:public => 0)

  slim :streams_public, :layout => :layout_streams
  end

