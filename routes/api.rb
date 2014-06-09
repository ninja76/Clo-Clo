# encoding: utf-8
get '/follow/:nodeID' do
  content_type :json
  result = $redis.hgetall(params[:nodeID])  
  t_key = $redis.hget(params[:nodeID], "key")
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
  h = {} 
  data = ""
  params.keys.each do |k|
   if k != "splat" and k != "captures" and k != "geo" and k != "nodeID"
    data = data + "#{k}:#{params[k]}:"
   end
   if k == "geo" and params[k] == "yes"
     geo = JSON.parse(geolookup(request.ip))
#     $redis.hset(params[:nodeID], "latitude", geo["lat"])
#     $redis.hset(params[:nodeID], "longitude", geo["long"])
#     puts "Inserting Geo Data #{geo["lat"]}, #{geo["long"]} "
   end
  end
  $redis.zadd(params[:nodeID],now,data)
  $redis.expire(params[:nodeID],86400)
  content_type :json
  return '{"result": "success"}' 
end

