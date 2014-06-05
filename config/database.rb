# Insert sql creds here
require_relative '../.env'
set :database, ENV["DATABASE_URL"]
