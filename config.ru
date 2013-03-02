require 'rubygems'
require 'sinatra'

require './app.rb'

set :env,  :production
disable :run

run Sinatra::Application
