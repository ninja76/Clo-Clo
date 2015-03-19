  get '/dashboard' do
    if session[:user_id]
      @streams = database[:streams].filter(:account_uid => session[:user_id])
      slim :dashboard
    else
      redirect '/login'
    end
  end

  get '/streams/public' do
  @formatted_streams = []
  @streams = database[:streams].filter(:public => 0)
  
  now = Time.now.to_i 
  ftime = ""
  @streams.each do |s|
    puts s.inspect
    if s[:updated_at]
      ftime = time_diff(s[:updated_at], now)
      s[:updated_at] = ftime
      @formatted_streams << {:id=>2, :account_uid=>1, :public=>0, :name=>"Des Moines, IA Weather", :description=>nil, :updated_at=>ftime}
      puts ftime
    end
  end
  slim :streams_public
  end


  get '/streams/detail' do
    @stream_id = params[:stream_id]

    slim :streams_detail, :layout => :layout_streams
  end

  def time_diff(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
  end
