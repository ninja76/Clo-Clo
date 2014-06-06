def geolookup(ip)
  require 'open-uri'
  geo  = JSON.parse(open("http://freegeoip.net/json/#{ip}") {|f| f.read })
  lat =  geo["latitude"]
  long = geo["longitude"]
  return "{ \"lat\": \"#{lat}\", \"long\": \"#{long}\" }"
end

class KeyGenerator
  require "digest/sha1"
  def self.generate(length = 8)
    Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[1..length]
  end
end
