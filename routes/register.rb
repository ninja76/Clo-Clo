post '/register/submit' do
  username = params[:username]
  password = params[:password]
  email = params[:email]
  duplicate = database["SELECT account_name FROM accounts WHERE account_name ='#{username}'"]
  if duplicate.count > 0
    return "{\"result\": \"fail\", \"error\": \"Username already in Use\"}"
  end 
  duplicate = database["SELECT email FROM accounts WHERE email ='#{email}'"]
  if duplicate.count > 0
    return "{\"result\": \"fail\", \"error\": \"Email already registered\"}"
  end
  if emailValidate(email) == 1
    return "{\"result\": \"fail\", \"error\": \"Invalid email address\"}"
  end
  key = KeyGenerator.generate
  database[:accounts].insert(:account_name => username, :password => password, :email => email, :key => key, :created_at => Time.now)
  return "{\"result\": \"ok\", \"key\": \"#{key}\"}"
end
