# encoding: utf-8
get '/follow/:nodeID' do
  content_type :json
  result = $redis.zrange(params[:nodeID], 0, -1, withscores: true)
  t_key = $redis.hget("key:#{params[:nodeID]}", "key")
  if t_key == params[:key]
    return result.to_json
  end
  if !t_key
    return result.to_json
  end
  if t_key != params[:key]
    return '{"result": "access deined to node"}'
  end
end

get '/create/:nodeID' do
  # Update Time stamp
  now = Time.now.to_f
  data = ""
  params.keys.each do |k|
    if k != "splat" and k != "captures" and k != "geo" and k != "nodeID" and k != "key"
     data = data + "#{k}:#{params[k]}:"
    end
    if k == "key"
      $redis.hset("key:#{params[:nodeID]}", "key", params[k])
    end
  end
  $redis.zadd(params[:nodeID],now,data)
  $redis.expire(params[:nodeID],86400)
  content_type :json
  return "{\"result\": \"success\", \"created_at\": #{now}}" 
end

