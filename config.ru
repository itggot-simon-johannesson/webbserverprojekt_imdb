#Use bundler to load gems
require 'bundler'

#Load gemms from Gemfile
Bundler.require

#Load models
require_relative 'models/baseclass.rb'
require_relative 'models/users.rb'
require_relative 'models/sql.rb'
require_relative 'models/films.rb'
require_relative 'models/genre.rb'

#Load the app
require_relative 'imdb.rb'

#Make GET/PATCH/DELETE/POST work
use Rack::MethodOverride

#Run the application
run Imdb