require 'sinatra'
require 'sinatra/sequel'
require_relative 'config/database.rb'

root = ::File.dirname(__FILE__)

configure :development do
 #set :database, "sqlite:///#{root}/data/spice.db"
 #set :database, "mysql://awsuser:flash109@myspiceinstance.cevpvmksyaz2.us-east-1.rds.amazonaws.com:3306/spice"
 #set :show_exceptions, true
end

configure :production do
#set :database, URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')
# set :database, "mysql://awsuser:flash109@myspiceinstance.cevpvmksyaz2.us-east-1.rds.amazonaws.com:3306/spice"
# set :database, "sqlite:///#{root}/data/spice.db"
# set :show_exceptions, true
end
puts "the accounts table doesn't exist" if !database.table_exists?('accounts')

migration "create the sensors table" do
  database.create_table :accounts do
    primary_key :id
    text      :account_name
    text      :key
    text      :email
    text      :password
    date      :last_update
  end
end

migration "alter accounts" do
  database.alter_table :accounts do
  end
end

Sequel::Model.db.extension(:pagination)
