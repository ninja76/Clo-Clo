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
   
  result = $redis.zrange(params[:streamID], 0, -1, withscores: true)
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

  data = "{"
  params.keys.each do |k|
    if k != "splat" and k != "captures" and k != "geo" and k != "streamID" and k != "key" and k != "stream_id"
      data = data + "{#{k}: #{params[k]}},"
    end
  end
  data = data.chop + "}"
  data = data + ";;#{now}"
  $redis.zadd(params[:streamID],now,data)
  $redis.expire(params[:streamID],86400)

  # Update stream last update field
  database[:streams].where(:id => streamID).update(:updated_at => now);

  content_type :json
  return "{\"result\": \"success\", \"created_at\": #{now}}"
end
