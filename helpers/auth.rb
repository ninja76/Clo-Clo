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
  if database[:accounts][:twitter_uid => streamMeta[:account_uid], :key => proposedKey]
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
  return database[:accounts][:twitter_uid => uid]
end

##
## Get Stream Meta Data
##
def getStreamMeta(streamID)
  return database[:streams][:id => streamID]
end

##
## get stream id from node and key
##
def getStreamIdfromNodeKey(node, key)
  account = database[:accounts][:key => key]
  if account
    rec = database[:streams][:name => node, :account_uid => account[:twitter_uid].to_s]
  end
  if rec
    return rec[:id]
  else
    return false  
  end
end

##
## returns account_id of given key
##
def getIdfromKey(key)
  rec = database[:accounts][:key => key]
  if rec
    return rec[:twitter_uid]
  end
  return false
end
