 def time_diff(start_time)
    end_time = Time.now.to_i
    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
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
  def self.generate(length = 20)
    Digest::SHA1.hexdigest(Time.now.to_s + rand(19573047).to_s)[1..length]
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
