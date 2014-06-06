post '/register/submit' do
  username = params[:username]
  password = params[:password]
  email = params[:email]
  key = KeyGenerator.generate
  database[:accounts].insert(:account_name => username, :password => password, :email => email, :key => key, :created_at => Time.now)
  return "{\"result\": \"ok\", \"key\": \"#{key}\"}"
end
