def protected!
  return if authorized?
  redirect '/login'
end

def authorized?
  if session[:user_id]
    return true
  else
    return false
  end 
end

def isLoggedIn(session)
  if session[:user_id]
    return true
  else
    return false
  end
end

##
## Validate that the supplied key matches the actual key for the requested resource
##
def validateKey(proposedKey, streamID)
  streamMeta = database[:streams][:id => streamID]
  puts "#{streamMeta[:account_uid]} #{proposedKey}"
  if database[:accounts][:id => streamMeta[:account_uid], :key => proposedKey]
    puts "key matches"
    return true
  end
  puts "key invalid"
  return false
end

