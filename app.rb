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
      "/css/style.css",
      "/css/default.css"
    ]

    js :main, [
      "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js",
      "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js",
      "/js/modernizr.custom.js",
      "/js/main.js"
    ]
    js :charts, [
      "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js",
      "//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js",
      "/js/modernizr.custom.js",
      "//www.google.com/jsapi",
      "/js/streams.js"
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
