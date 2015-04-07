require 'sinatra'
require 'sinatra/sequel'
require_relative 'config/database.rb'

root = ::File.dirname(__FILE__)

configure :development do
  #set :database, "sqlite:///#{root}/data/spice.db"
  set :database, ENV['DATABASE_URL']
  set :show_exceptions, true
end

configure :production do
  set :database, URI.parse(ENV['DATABASE_URL'])
  #set :database, "sqlite:///#{root}/data/spice.db"
  set :show_exceptions, true
end
puts "The accounts table doesn't exist" if !database.table_exists?('accounts')
puts "The streams table doesn't exist" if !database.table_exists?('streams')

migration "create the accounts table" do
  database.create_table :accounts do
    primary_key :id
    text      :account_name
    text      :twitter_uid
    text      :photo_url
    text      :key
    text      :email
    text      :password
    dateTime  :created_at
  end
end

migration "alter accounts" do
  database.alter_table :accounts do
  end
end

migration "create the streams table" do
  database.create_table :streams do
    primary_key :id
    int       :account_uid
    int       :public
    text      :name
    text      :description
    tinyint   :strict
    text      :uom
    text      :fields
    dateTime  :created_at
    dateTime  :updated_at
  end
end

migration "alter streams" do
  database.alter_table :streams do
  end
end
Sequel::Model.db.extension(:pagination)
