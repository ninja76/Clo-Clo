def isLoggedIn(session)
  if session[:user_id]
    return true
  else
    return false
  end
end

def validateKey(proposedKey, streamUID)
  if database[:accounts][:id => streamUID, :key => proposedKey]
    return false
  end
  return true
end

def geolookup(ip)
  require 'open-uri'
  geo  = JSON.parse(open("http://freegeoip.net/json/#{ip}") {|f| f.read })
  lat =  geo["latitude"]
  long = geo["longitude"]
  return "{ \"lat\": \"#{lat}\", \"long\": \"#{long}\" }"
end

class KeyGenerator
  require "digest/sha1"
  def self.generate(length = 12)
    Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[1..length]
  end
end

def emailValidate(email)
  unless email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
    return 1
  else
    return 1 unless validate_email_domain(email)
  end
  return 0
end

require 'resolv'
def validate_email_domain(email)
      domain = email.match(/\@(.+)/)[1]
      Resolv::DNS.open do |dns|
          @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
      end
      @mx.size > 0 ? true : false
end
