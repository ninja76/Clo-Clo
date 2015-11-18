get '/auth/twitter/callback' do
  now     = Time.now;
  session[:user_id] = env['omniauth.auth']['uid']
  session[:access_token] = env['omniauth.auth']['credentials']['token']
  session[:access_token_secret] = env['omniauth.auth']['credentials']['secret']
  nickname = env['omniauth.auth']['info']['nickname']
  uid = env['omniauth.auth']['uid']
  name = env['omniauth.auth']['info']['name']
  photo_url = ""
  rec = database[:accounts].first(:twitter_uid => session[:user_id])
  if rec
     puts "User already exists...#{nickname} #{rec.inspect}"
  else
     puts "Creating new user....#{nickname} @#{now}"
     new_user_id = database[:accounts].insert(:account_name => nickname, :created_at => now, :photo_url => photo_url, :twitter_uid => uid, :key => KeyGenerator.generate)
     #database[:accounts].insert(:account_name => nickname, :created_at => now, :photo_url => photo_url, :twitter_uid => session[:twitter_uid], :access_token => session[:access_token], :access_token_secret => session[:access_token_secret], :key => KeyGenerator.generate)
  end
  redirect to('/dashboard')
end

get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem
  # so you can implement this as you please
end
