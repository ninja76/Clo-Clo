  get '/dashboard/add' do
    @isloggedin = isLoggedIn(session)

    if @isloggedin == false
      redirect '/login'
    end

    slim :dashboard_streams_add
  end

##
## Delete stream from dashboard
##

  delete '/dashboard/delete/:streamID' do 
    
    if @isloggedin == false || !database[:streams][:account_uid => session[:user_id], :id => params[:streamID]]
      content_type :json
      "{\"result\": \"error\", \"message\": \"access denied\"}"
    end

    puts "deleting stream #{params[:streamID]}"
    delete = database[:streams].filter(:id => params[:streamID]).delete

    content_type :json 
    "{\"result\": \"success\", \"message\": \"stream removed\"}"
  end
##
## Create new stream from dashboard
##
  post '/dashboard/create' do
    @isloggedin = isLoggedIn(session)

    if @isloggedin == false
      return "{\"result\": \"error\", \"message\": \"access denied\"}"
    end

    name = params[:stream_name]
    desc = params[:stream_desc]

    stream_id = database[:streams].insert(:account_uid => session[:user_id], :name => name, :description => desc, :public => 0, :created_at => Time.now, :updated_at => Time.now)
    content_type :json
    return "{\"result\": \"success\", \"stream_id\": \"#{stream_id}\", \"created_at\": #{Time.now.to_i}}"
  end

  get '/dashboard/account' do
    @isloggedin = isLoggedIn(session)
    if @isLoggedin == false
      redirect '/login'
    end
    @user_meta = database[:accounts][:id => session[:user_id]]
    slim :dashboard_account
  end

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

