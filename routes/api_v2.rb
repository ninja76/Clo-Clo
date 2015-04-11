##
## Create New Stream
##
post '/streams' do
  key    = params[:key]
  name   = params[:name]
  desc   = params[:desc]
  public = params[:public]
  
  if !validateKey(key)
    halt 401, "invalid key"
  end

  field_default_data = ":field1,,,:field2,,,:field3,,,:field4,,,:field,,,"
  user_meta = getUserMetaByKey(key)
  stream_id = database[:streams].insert(:account_uid => user_meta[:id], :name => name, :description => desc, :public => 0, :created_at => Time.now, :updated_at => Time.now, fields => field_default_data)  
  content_type :json
  return "{\"result\": \"success\", \"stream_id\": \"#{stream_id}\", \"created_at\": #{Time.now.to_i}}"
end

##
## Get all stream metadata for key
get '/streams' do

  if params[:key]
    key = params[:key]
    user_meta = getUserMetaByKey(key)
    if !user_meta
      halt 401, "invalid key"
    end
    streams = database[:streams].filter(:account_uid => user_meta[:id])
  else
     streams = database[:streams].filter(:public => 0)
  end
  jdata = []
  streams.each do |d|
    jdata << {:id => d[:id], :name => d[:name], :description => d[:description], :updated_at => d[:updated_at]}
  end

  content_type :json
  return jdata.to_json
end

##
##  Get Stream Data
##
get '/streams/:streamID' do
  streamID = params[:streamID]
  streamMeta = getStreamMeta(streamID)

  if !streamMeta
    halt 204, "No content found"
  end
  if streamMeta[:public] == 1 && !validateStreamAccess(params[:key], streamID)
    halt 401, "not authorized"
  end

  result = $redis.zrange(streamID, 0, -1, withscores: true)
  a = result.map{|s| { timestamp: s[1], data: s[0].split(';;')[0] } }
  if streamMeta[:public] == 0
    content_type :json
    return a.to_json
  end
end

##
## Update a Stream New Skool
##
put '/streams/:streamID' do
  streamID = params[:streamID]
  now = Time.now.to_i
  payload =  JSON.parse(request.body.read)

  if !validateStreamAccess(payload['key'], streamID)
    halt 401, "invalid key"
  end

  data = ""
  payload.each do |k, v| 
    if k != "splat" and k != "captures" and k != "geo" and k != "streamID" and k != "key" and k != "stream_id"
      data = data + "#{k}: #{v},"
    end
  end
  data = data.chop
  data = data + ";;#{now}"
  $redis.zadd(streamID,now,data)
  $redis.expire(streamID,86400)
  # Update stream last update field
  database[:streams].where(:id => streamID).update(:updated_at => Time.now);

  status 200
end

##
##  Update a Stream Legacy
##
get '/api/update' do
  streamID = params[:stream_id]
  now = Time.now.to_i

  if !validateStreamAccess(params[:key], streamID)
    puts "whoops!"
    content_type :json
    return '{"result": "failed", "message": "access denied"}'
  end

  data = ""
  params.keys.each do |k|
    if k != "splat" and k != "captures" and k != "geo" and k != "streamID" and k != "key" and k != "stream_id"
      data = data + "#{k}: #{params[k]},"
    end
  end

  data = data.chop + ";;#{now}"
  $redis.zadd(streamID,now,data)
  $redis.expire(streamID,86400)

  # Update stream last update field
  database[:streams].where(:id => streamID).update(:updated_at => Time.now);

  status 200
end

##
##  returns chart data for use with dashboard
##
get '/chart_data' do
  now = Time.now.to_i
  ## By default return the  last 24 hours of data
  ## If the timeframe parameter is entered (in seconds ex. 86400 = 24 hours) set the time frame to that value
  ##
  if params[:timeframe] && params[:timeframe] != "undefined"
    timerange = params[:timeframe].to_i
  else
    timerange = 86400
  end

  @streams = database[:streams][:id => params[:stream_id]]
  result = $redis.zrangebyscore(@streams[:id],now-timerange ,now, withscores: true)
  a = result.map{|s| { timestamp: s[1], data: s[0].split(';;')[0] } }

  series = result.map{|s| s[0].split(';;')[0] }
  series_data_array = Array.new
  series_data_array.push(Array.new) #timestamps array
  series_data_array.push(Array.new) #Label array
  series_data_array.push(Array.new) #UoM array

  # Get data labels and push them to array spot 1 and create a new array for each data point
  if !series[0]
    content_type :json
    return "{\"result\": \"error\", \"message\": \"no data found \"}"    
  end

  series[0].split(',').each do |s|
    series_data_array.push(Array.new)
    if @streams[:fields] != nil
      @streams[:fields].split(':').drop(1).each do |f|
          name = f.split(',')[0]
          if s.split(': ')[0] == name && f.split(',')[2] != nil
             series_data_array[1].push(f.split(',')[2])
          end
          if s.split(': ')[0] == name && f.split(',')[2] == nil
            series_data_array[1].push(s.split(': ')[0])
          end
          if  s.split(': ')[0] == name 
            if f.split(',')[1] != nil
              series_data_array[2].push(f.split(',')[1])
            else
              series_data_array[2].push("")
            end
         end
      end
    end
  end

  # Get Time Series Data and push array spot 0
  series_ts = result.map{|s| s[1]} 

  # Go over each timstamp and only keep the ones that fall into the timeframe
  series_ts.each do |s|
    series_data_array[0].push(s)
  end
  # truncate the actual data to the last x number of records in the timestamp array
  series.each do |item|
    s_count = 3
    item.split(',').each do |key|
      series_data_array[s_count].push(key.split(': ')[1])
      s_count = s_count+1
    end
  end

  content_type :json
  return series_data_array.to_json
end

