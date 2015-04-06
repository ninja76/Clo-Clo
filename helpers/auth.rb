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
def validateStreamAccess(proposedKey, streamID)
  streamMeta = database[:streams][:id => streamID]
  if database[:accounts][:id => streamMeta[:account_uid], :key => proposedKey]
    return true
  end
  return false
end

##
## Get user meta data from key or uid
##
def getUserMetaByKey(key)
  return database[:accounts][:key => key]
end

def getUserMeta(uid)
  return database[:accounts][:id => uid]
end

##
## Get Stream Meta Data
##
def getStreamMeta(streamID)
  return database[:streams][:id => streamID]
end

##
## Simply validates that a given key infact exists
##
def validateKey(key)
  if database[:accounts][:key => key]
    return true
  end
  return false
end


