#Use bundler to load gems
require 'bundler'

#Load gemms from Gemfile
Bundler.require

#Load models

#Load the app
require_relative 'imdb.rb'

#Make GET/PATCH/DELETE/POST work
use Rack::MethodOverride

#Run the application
run Imdb