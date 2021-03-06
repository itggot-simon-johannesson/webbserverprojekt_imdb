require "pp"

class Imdb < Sinatra::Base

    enable :sessions
    register Sinatra::Flash

    before do
        params.delete(:captures) if params.key?(:captures) && params[:captures].empty?

        blacklist_login = ['/login', '/signup']
        blackpath = /^\/user\/\d+/

        if session[:id]
            @user = User.get({"value" => session[:id], "column_name" => "id", "like" => false})

            redirect "/user/#{session[:id]}" if blacklist_login.include?(request.path)
        else
            redirect "/login" if blackpath.match(request.path)                
        end

    end

    get '/' do
        slim :main
    end

    get '/signup' do
        slim :signup
    end

    post '/signup' do
        user = User.create(params)

        if user.class == String
            flash[:error] = user
            redirect "signup"
        else
            flash[:error] = "suxes"
            redirect "/login"
        end

    end
    
    get '/login' do
        slim :login
    end

    post '/login' do
        user = User.login(params)
        if user and params["mail"] and params["password"]
            session[:id] = user.id
            redirect "/"
        else
            flash[:error] = 'incorrect username or password'
            redirect "/login"
        end

    end

    get '/user/:id' do
        if params["id"].to_i != @user.id
            @profile = User.get({"value" => params["id"], "column_name" => "id", "like" => false})
        end

        slim :profile
    end

    get '/logout' do
		session.destroy
		redirect '/login'
    end

    post '/search' do
        redirect "/search?" + URI.encode_www_form(params)
    end

    post '/filter' do
        redirect "/search?" + URI.encode_www_form(params)
    end

    get '/search' do
        @filter = params
        @search_page = true
        slim :search
    end

    get '/film/:id' do
        id = params['id'].to_i
        @film = Film.get("value" => id, "column_name" => "id", "like" => false)
        slim :film
    end

end