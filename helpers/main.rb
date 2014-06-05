def geolookup(ip)
  require 'open-uri'
  geo  = JSON.parse(open("http://freegeoip.net/json/#{ip}") {|f| f.read })
  lat =  geo["latitude"]
  long = geo["longitude"]
  return "{ \"lat\": \"#{lat}\", \"long\": \"#{long}\" }"
end

