##
## Primary dashboard view
##
  get '/dashboard' do
    protected!

    @formatted_streams = []
    streams = database[:streams].filter(:account_uid => session[:user_id])
    streams.each do |s|
      @formatted_streams << {:id=>s[:id], :name=> s[:name], :description=> s[:description], :updated_at=>time_diff(s[:updated_at])}
    end
      slim :dashboard
  end

  get '/dashboard/add' do
    protected!

    slim :dashboard_streams_add
  end

##
## Delete stream from dashboard
##
  delete '/dashboard/delete/:streamID' do 
    protected!

    if !database[:streams][:account_uid => session[:user_id], :id => params[:streamID]]
      status 401
    end

    delete = database[:streams].filter(:id => params[:streamID]).delete

    status 200
  end
##
## Create new stream from dashboard
##
  post '/dashboard/create' do
    protected!

    name = params[:stream_name]
    desc = params[:stream_desc]

    stream_id = database[:streams].insert(:account_uid => session[:user_id], :name => name, :description => desc, :public => 0, :created_at => Time.now, :updated_at => Time.now)
    content_type :json
    return "{\"stream_id\": \"#{stream_id}\", \"created_at\": #{Time.now.to_i}}"
  end

##
## Dashboard account view
##
  get '/dashboard/account' do
    protected!

    @user_meta = database[:accounts][:id => session[:user_id]]
    slim :dashboard_account
  end

##
## Dashboard stream detail view
##
  get '/dashboard/detail' do
    protected!
    @charts = ''

    @stream_meta = database[:streams][:id => params[:stream_id]]
    slim :dashboard_streams_detail
  end

##
## Public streams view
##
  get '/public' do
    @formatted_streams = []
    streams = database[:streams].filter(:public => 0)
    puts streams.inspect
    streams.each do |s|
      @formatted_streams << {:id=>s[:id], :name=> s[:name], :description=> s[:description], :updated_at=> time_diff(s[:updated_at])}
    end
    slim :public_streams
  end

##
## Public stream detail
##
  get '/public/detail' do
    @charts = ''
    @stream_meta = database[:streams][:id => params[:stream_id]]

    slim :public_streams_detail
  end

##
## Dashboard update stream route
## 
  post '/dashboard/update/:streamID' do
    protected!

    if !database[:streams][:account_uid => session[:user_id], :id => params[:streamID]]
      status 401
    end

    updated_name = params[:name]
    updated_desc = params[:desc]
    database[:streams].where(:id => params[:streamID]).update(:name => updated_name, :description => updated_desc);

    status 200
  end

