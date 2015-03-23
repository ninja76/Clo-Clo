get '/api/create' do
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


get '/api/streams' do
  streamID = params[:stream_id]
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
  ## Returns last 24 hours of data
  last24 = 86400;
  @streams = database[:streams][:id => params[:stream_id]]
  result = $redis.zrange(@streams[:id], 0, -1, withscores: true)
  a = result.map{|s| { timestamp: s[1], data: s[0].split(';;')[0] } }

  series = result.map{|s| s[0].split(';;')[0] }
  
  series_data_array = Array.new
  series_data_array.push(Array.new)
  series_data_array.push(Array.new)

  # Get data labels and push them to array spot 1 and create a new array for each data point
  series[0].split(',').each do |s|
    series_data_array.push(Array.new)
    series_data_array[1].push(s.split(': ')[0])
  end
  now = Time.now.to_i
  p_count = 0
  # Get Time Series Data and push array spot 0
  series_ts = result.map{|s| s[1]} 
  series_ts.each do |s|
    if s > now - last24
      p_count = p_count+1
      series_data_array[0].push(s)
    end
  end

  series.last(series_data_array[0].length).each do |item|
    s_count = 2
    item.split(',').each do |key|
      series_data_array[s_count].push(key.split(': ')[1])
      s_count = s_count+1
    end
  end

  return series_data_array.to_json
end

