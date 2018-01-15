class Imdb < Sinatra::Base

    enable :session

    get '/' do
        slim :main
    end

end