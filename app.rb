# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/assetpack'
require 'json/ext'
require 'slim'
require 'sequel'
require 'redis'
require './database'
require './config/redis'

Sinatra::Application.register Sinatra::AssetPack

class MyApp < Sinatra::Application
  enable :sessions

  use Rack::Session::Cookie, :expire_after => 60*60*3, :secret => 'summeriscoolerthenwinter'
  register Sinatra::AssetPack
  enable :inline_templates
  assets do
    serve '/js',     from: 'public/js'        # Default
    serve '/css',    from: 'public/css'       # Default
    serve '/images',  from: 'public/images'     # Default

    css :bootstrap, [
      "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css",
      "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css",
      "/css/bootswatch.min.css",
      "//cdn.datatables.net/1.10.0/css/jquery.dataTables.css"
    ]

    js :jsapp, [ "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js",
     "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js",
     "//cdn.datatables.net/1.10.0/js/jquery.dataTables.js",
     "//cdn.datatables.net/plug-ins/e9421181788/integration/bootstrap/3/dataTables.bootstrap.js",
     "/js/main.js"
    ]

    css_compression :simple
    js_compression :jsmin
    prebuild true
  end

  configure do
    set :author, "Bryan"
    set :desc, "Turbo Spice"
    set :public_dir, File.dirname(__FILE__) + '/public'
    set :views, File.dirname(__FILE__) + '/templates'
  end
end

require_relative 'routes/init'
require_relative 'helpers/init'
