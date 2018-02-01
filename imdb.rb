class Imdb < Sinatra::Base

    enable :session

    get '/' do
        slim :main
    end

    get '/signup' do
        slim :signup
    end

    post '/signup' do
        user_info = []
        
        user_info << @firstname = params[:firstname].to_s
        user_info << @lastname = params[:lastname].to_s
        user_info << @username = params[:username].to_s
        user_info << @mail = params[:mail].to_s
        user_info << @password = params[:password].to_s

        Users.create(user_info)

        
        slim :signup
    end
    
    get '/login' do
        slim :login
    end

    post '/login' do
        user_info = []

        user_info << @mail_username = params[:mail].to_s
        user_info << @password = params[:password].to_s
        
        Users.login(user_info, session)

        slim :login
    end

end