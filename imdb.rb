class Imdb < Sinatra::Base

    enable :sessions
    register Sinatra::Flash

    before do
        params.delete(:captures) if params.key?(:captures) && params[:captures].empty?

        blacklist_login = ['/login', '/signup']
        blackpath = /^\/user\/\d+/

        if session[:id]
            @user = User.get(session[:id], "id", false)

            if blacklist_login.include?(request.path)
                redirect "/user/#{session[:id]}"
            end

        else
            if blackpath.match(request.path)
                redirect "/login"
            end
        
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
            p @profile = User.get(params["id"], "id", false)
        end

        slim :profile
    end

    get '/logout' do
		session.destroy
		redirect '/login'
    end

    post '/search' do
        redirect Search.path(params)
    end

    post '/filter' do
        redirect Search.path(params)
    end

    get '/search' do
        @filter = params
        @search_page = true
        slim :search
    end

    get '/film/:id' do
        @film_id = params['id'].to_i
        slim :film
    end


# (byebug) path
# "/search?film=on&user=on&worker=on&search=hej jag heter simon&"
# (byebug) URI.encode(path)
# "/search?film=on&user=on&worker=on&search=hej%20jag%20heter%20simon&"
# (byebug) filter
# {"film"=>"on", "user"=>"on", "worker"=>"on", "search"=>"hej jag heter simon"}
# (byebug) filter.join("&")
# *** NoMethodError Exception: undefined method `join' for #<Hash:0x0055e30460abc0>

# nil
# (byebug) URI.encode_www_form(filter)
# "film=on&user=on&worker=on&search=hej+jag+heter+simon"
# (byebug) x = URI.encode_www_form(filter)
# "film=on&user=on&worker=on&search=hej+jag+heter+simon"
# (byebug) URI.decode(x)
# "film=on&user=on&worker=on&search=hej+jag+heter+simon"
# (byebug) URI.decode_www_form(x)
# [["film", "on"], ["user", "on"], ["worker", "on"], ["search", "hej jag heter simon"]]
# (byebug) URI.decode_www_form(x).to_hash
# *** NoMethodError Exception: undefined method `to_hash' for #<Array:0x0055e3054e8368>
# Did you mean?  to_h

# nil
# (byebug) URI.decode_www_form(x).to_h
# {"film"=>"on", "user"=>"on", "worker"=>"on", "search"=>"hej jag heter simon"}

end