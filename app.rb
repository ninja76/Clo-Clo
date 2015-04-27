# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/assetpack'
require 'sinatra/config_file'
require 'json/ext'
require 'slim'
require 'omniauth-twitter'
require 'sequel'
require 'redis'
require './database'
require './config/redis'

Sinatra::Application.register Sinatra::AssetPack

class MyApp < Sinatra::Application
  enable :sessions
  register Sinatra::AssetPack
  register Sinatra::ConfigFile
  config_file './config/config.yaml'

  assets do
    serve '/js',     from: 'public/js'        # Default
    serve '/css',    from: 'public/css'       # Default
    serve '/images',  from: 'public/images'   # Default

    css :bootstrap, [
      "//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css", 
      "/css/style.css",
      "/css/custom.css",
      "/css/ladda-themeless.min.css"
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
      "/js/lib/spin.min.js",
      "/js/streams.js"
    ]

    css_compression :simple
    js_compression :jsmin
    prebuild true
  end

  configure do
    set :public_dir, File.dirname(__FILE__) + '/public'
    set :views, File.dirname(__FILE__) + '/templates'
    use OmniAuth::Builder do
      provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
    end
  end
  
  configure :development do
      enable :logging, :dump_errors, :inline_templates
      enable :methodoverride
    end

    configure :production do
      enable :dump_errors, :inline_templates
      enable :methodoverride
    end


end

require_relative 'routes/init'
require_relative 'helpers/init'
