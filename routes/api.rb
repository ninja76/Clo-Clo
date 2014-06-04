# encoding: utf-8
get '/follow/:node' do
  
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
   if k != "splat" and k != "captures"
     puts "Inserting new Key #{params[:nodeID]}, #{value}"
     $redis.hsetnx(params[:nodeID], k, params[k])
   end
  end
  $redis.expire(params[:nodeID],86400)
  return "Done"
end

