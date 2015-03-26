##
## Create New Stream
##
post '/api/streams' do
  key    = params[:key]
  name   = params[:name]
  desc   = params[:desc]
  public = params[:public]

  user_meta = database[:accounts][:key => key]
  if !user_meta
    content_type :json
    return '{"result": "failed", "message": "invalid key"}'
  end

  stream_id = database[:streams].insert(:account_uid => user_meta[:id], :name => name, :description => desc, :public => 0, :created_at => Time.now, :updated_at => Time.now)  
  content_type :json
  return "{\"result\": \"success\", \"stream_id\": \"#{stream_id}\", \"created_at\": #{Time.now.to_i}}"
end

##
##  Get Stream Data
##
get '/api/streams/:streamID' do
  streamMeta = database[:streams][:id => streamID]
  result = $redis.zrange(streamID, 0, -1, withscores: true)
  a = result.map{|s| { timestamp: s[1], data: s[0].split(';;')[0] } }
  if streamMeta[:public] == 0
    content_type :json
    return a.to_json
  end

  if streamMeta[:public] == 1 && validateKey(params[:key], streamID)
    content_type :json
    return '{"result": "failed", "message": "invalid key"}'
  end
end

##
## Update a Stream New Skool
##
put '/api/streams/:streamID' do
  streamID = params[:streamID]
  now = Time.now.to_i
  payload =  JSON.parse(request.body.read)
  streamMeta = database[:streams][:id => streamID]
  proposedKey = payload['key']
  actualKey = database[:accounts][:id => streamMeta[:account_uid], :key => proposedKey]

  if !actualKey
    content_type :json
    return '{"result": "failed", "message": "key required for this node"}'
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
  database[:streams].where(:id => streamID).update(:updated_at => now);

  puts "Updating #{streamID} with #{data}"

  content_type :json
  return "{\"result\": \"success\", \"created_at\": #{now}}"
end

##
##  Update a Stream Legacy
##
get '/api/update' do
  streamID = params[:stream_id]
  # Update Time stamp
  now = Time.now.to_i

  streamMeta = database[:streams][:id => streamID]
  proposedKey = params[:key]
  actualKey = database[:accounts][:id => streamMeta[:account_uid], :key => proposedKey]

  if !actualKey 
    content_type :json
    return '{"result": "failed", "message": "key required for this node"}'
  end

  data = ""
  params.keys.each do |k|
    if k != "splat" and k != "captures" and k != "geo" and k != "streamID" and k != "key" and k != "stream_id"
      data = data + "#{k}: #{params[k]},"
    end
  end
  data = data.chop
  data = data + ";;#{now}"
  $redis.zadd(streamID,now,data)
  $redis.expire(streamID,86400)

  # Update stream last update field
  database[:streams].where(:id => streamID).update(:updated_at => now);

  content_type :json
  return "{\"result\": \"success\", \"created_at\": #{now}}"
end


get '/api/chart_data' do
  ## By default return the  last 24 hours of data
  ## If the timeframe parameter is entered (in seconds ex. 86400 = 24 hours) set the time frame to that value
  ##
  if params[:timeframe]
    timerange = params[:timeframe].to_i
  else
    timerange = 86400
  end
  @streams = database[:streams][:id => params[:stream_id]]
  result = $redis.zrange(@streams[:id], 0, -1, withscores: true)
  a = result.map{|s| { timestamp: s[1], data: s[0].split(';;')[0] } }

  series = result.map{|s| s[0].split(';;')[0] }
  series_data_array = Array.new
  series_data_array.push(Array.new)
  series_data_array.push(Array.new)

  # Get data labels and push them to array spot 1 and create a new array for each data point
  if !series[0]
    content_type :json
    return "{\"result\": \"error\", \"message\": \"no data found \"}"    
  end

  series[0].split(',').each do |s|
    series_data_array.push(Array.new)
    series_data_array[1].push(s.split(': ')[0])
  end
  now = Time.now.to_i
  # Get Time Series Data and push array spot 0
  series_ts = result.map{|s| s[1]} 

  # Go over each timstamp and only keep the ones that fall into the timeframe
  series_ts.each do |s|
    if s > now - timerange
      series_data_array[0].push(s)
    end
  end
  puts "Sending only the last #{series_data_array[0].length} records"
  # truncate the actual data to the last x number of records in the timestamp array
  series.last(series_data_array[0].length).each do |item|
    s_count = 2
    item.split(',').each do |key|
      series_data_array[s_count].push(key.split(': ')[1])
      s_count = s_count+1
    end
  end

  return series_data_array.to_json
end

