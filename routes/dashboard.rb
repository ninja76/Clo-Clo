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

  post '/dashboard/update/:streamID' do
    updated_name = params[:name]
    updated_desc = params[:desc]
    puts "Updating Stream #{params[:streamID]} #{updated_name} #{updated_desc}"

    database[:streams].where(:id => params[:streamID]).update(:name => updated_name, :description => updated_desc);
    
    content_type :json
    return '{"result": "success"}'
  end

