# encoding: utf-8
get '/follow/:nodeID' do
  content_type :json
  puts $redis.hgetall(params[:nodeID])  
end

post '/create/:nodeID' do
  data = JSON.parse(request.body.read)
  redis.set("mykey", "hello world")
  test = redis.get("mykey")
  puts test
  data.to_json
end

get '/create/:nodeID' do
  # Update Time stamp
  insert = $redis.hset(params[:nodeID], "updated_time", Time.now.to_f)
  params.keys.each do |k|
   value = "{\"#{k}\":\"#{params[k]}\"}"
   if k != "splat" and k != "captures" and k != "geo"
     puts "Inserting new Key #{params[:nodeID]}, #{value}"
     $redis.hset(params[:nodeID], k, params[k])
   end
   if k == "geo" and params[k] == "yes"
     geo = JSON.parse(geolookup(request.ip))
     $redis.hset(params[:nodeID], "latitude", geo["lat"])
     $redis.hset(params[:nodeID], "longitude", geo["long"])
     puts "Inserting #{geo["lat"]}, #{geo["long"]} "
   end
  end
  $redis.expire(params[:nodeID],86400)
  puts $redis.hgetall(params[:nodeID])
  
  content_type :json
  return '{"result": "success"}' 
end

