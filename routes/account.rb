
post '/login/submit' do
  username = params[:username].downcase
  password = params[:password]
  is_valid = database[:accounts][:account_name => username, :password => password]
  if is_valid
    puts "#{username} successfully logged in!"
    session[:user_id] = is_valid[:id]
    return "{\"result\": \"success\"}"
  end 
  puts "#{username} failed to login!"
  content_type :json
  return "{\"result\": \"fail\", \"error\": \"Invalid username/password\"}"
end

post '/register/submit' do
  username = params[:username].downcase
  password = params[:password]
  #email = params[:email]
  email = ""
  duplicate = database["SELECT account_name FROM accounts WHERE account_name ='#{username}'"]
  if duplicate.count > 0
    return "{\"result\": \"fail\", \"error\": \"Username already in Use\"}"
  end 
  if username == "" or password == "" or username.length < 4 or password.length < 4
    return "{\"result\": \"fail\", \"error\": \"Invalid username/password\"}"
  end
#  duplicate = database["SELECT email FROM accounts WHERE email ='#{email}'"]
#  if duplicate.count > 0
#    return "{\"result\": \"fail\", \"error\": \"Email already registered\"}"
#  end
#  if emailValidate(email) == 1
#    return "{\"result\": \"fail\", \"error\": \"Invalid email address\"}"
#  end
  key = KeyGenerator.generate
  database[:accounts].insert(:account_name => username, :password => password, :email => email, :key => key, :created_at => Time.now)

  session[:user_id] = username
  redirect '/dashboard'
#  return "{\"result\": \"ok\", \"key\": \"#{key}\"}"
end
