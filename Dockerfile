FROM base

MAINTAINER ninja76 "https://github.com/ninja76/clo-clo

# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y --force-yes build-essential wget git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev mysql-client libmysqlclient-dev
RUN apt-get clean

RUN wget -P ~/src ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz
RUN cd ~/src; tar xvf ruby-2.1.0.tar.gz
RUN cd ~/src/ruby-2.1.0; ./configure; make install

RUN gem update --system
RUN gem install bundler
RUN gem install rack
RUN git clone https://github.com/ninja76/clo-clo /opt/cloclo
RUN cd /opt/cloclo; bundle install
#RUN echo 'ENV["DATABASE_URL"] = "mysql://user/password@mysqlhost:3306/spice"' > /opt/cloclo/.env.rb
EXPOSE 4567
CMD ["/usr/local/bin/foreman","start","-d","/opt/cloclo"]




