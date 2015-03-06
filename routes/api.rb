# encoding: utf-8
get '/api/follow/:nodeID' do
  content_type :json
  result = $redis.zrange(params[:nodeID], 0, -1, withscores: true)
  a = result.map{|s| { timestamp: s[1], data: s[0] } }
  t_key = $redis.hget("key:#{params[:nodeID]}", "key")

  if t_key == params[:key] || !t_key
    content_type :json
    return a.to_json
  end

  if t_key != params[:key]
    content_type :json
    return '{"result": "denied"}'
  end
end

get '/api/last/:nodeID' do
  content_type :json
  result = $redis.zrange(params[:nodeID], 1, -1, withscores: true)
  a = result.map{|s| { timestamp: s[1], data: s[0] } }
  t_key = $redis.hget("key:#{params[:nodeID]}", "key")

  if t_key == params[:key] || !t_key
    content_type :json
    return a.to_json
  end

  if t_key != params[:key]
    content_type :json
    return '{"result": "denied"}'
  end
end

get '/api/create/:nodeID' do
  # Update Time stamp
  now = Time.now.to_f
  data = "{"
  t_key = $redis.hget("key:#{params[:nodeID]}", "key")
  if t_key && t_key != params[:key]
    content_type :json
    return '{"result": "key required for this node"}'
  end
  params.keys.each do |k|

    if k != "splat" and k != "captures" and k != "geo" and k != "nodeID" and k != "key"
      data = data + "{#{k}: #{params[k]}},"
    end
    if k == "key"
      $redis.hset("key:#{params[:nodeID]}", "key", params[k])
    end
  end
  data = data.chop + "}"
  $redis.zadd(params[:nodeID],now,data)
  $redis.expire(params[:nodeID],86400)
  content_type :json
  return "{\"result\": \"success\", \"created_at\": #{now}}" 
end

