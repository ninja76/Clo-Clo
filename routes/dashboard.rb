  get '/dashboard' do
  @isloggedin = isLoggedIn(session)  
  @formatted_streams = []
    if session[:user_id]
      streams = database[:streams].filter(:account_uid => session[:user_id])
      streams.each do |s|
        if s[:updated_at]
          @formatted_streams << {:id=>s[:id], :name=> s[:name], :description=> s[:description], :updated_at=>time_diff(s[:updated_at])}
        end
      end
      slim :dashboard
    else
      redirect '/login'
    end
  end

  get '/dashboard/detail' do
   @isloggedin = isLoggedIn(session) 
   if session[:user_id]
      @stream_meta = database[:streams][:id => params[:stream_id]]
      slim :dashboard_streams_detail, :layout => :layout_streams
    else
      redirect '/login'
    end
  end

  get '/streams/public' do
  @isloggedin = isLoggedIn(session)
  @formatted_streams = []
  streams = database[:streams].filter(:public => 0)
  streams.each do |s|
    if s[:updated_at]
      @formatted_streams << {:id=>s[:id], :name=> s[:name], :description=> s[:description], :updated_at=>time_diff(s[:updated_at])}
    end
  end
  slim :public_streams
  end


  get '/streams/detail' do
    @isloggedin = isLoggedIn(session)
    @stream_meta = database[:streams][:id => params[:stream_id]]
    slim :public_streams_detail, :layout => :layout_streams
  end



  def time_diff(start_time)
    end_time = Time.now.to_i
    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
  end
