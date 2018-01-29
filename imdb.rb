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
        
        user_info << @firstname = params[:firstname]
        user_info << @lastname = params[:lastname]
        user_info << @username = params[:username]
        user_info << @mail = params[:mail]
        user_info << @password = params[:password]

        Users.create(user_info)

        
        slim :signup
    end
    
    get '/login' do
        slim :login
    end

    post '/login' do
        user_info = []

        user_info << @mail_username = params[:mail]
        user_info << @password = params[:password]
        
        Users.login(user_info, session)

        slim :login
    end

end