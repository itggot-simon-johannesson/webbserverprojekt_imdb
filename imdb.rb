class Imdb < Sinatra::Base

    enable :sessions

    get '/' do





        if session[:login] == true
           p @user = Users.info_by_mail(session[:mail])
        end
        
        slim :main
    end

    get '/signup' do
        slim :signup
    end

    post '/signup' do
        user_info = []
        
        user_info << params[:firstname].to_s
        user_info << params[:lastname].to_s
        user_info << params[:username].to_s
        user_info << params[:mail].to_s
        user_info << params[:password].to_s

        Users.create(user_info)
        Users.login([user_info[3],user_info[4]], session)

        redirect "/"
    end
    
    get '/login' do
        slim :login
    end

    post '/login' do
        user_info = []

        user_info << params[:mail].to_s
        user_info << params[:password].to_s
        
        Users.login(user_info, session)

        if session[:login] == true
            redirect "/"
        else
            redirect "/login"
        end      

    end

    get '/users/:id' do
        if session[:login] == true

            @id = params['id'].to_i
            @user = Users.info_by_mail(session[:mail])

            if @user.type == "normal" and @id != @user.id
                redirect "/users/#{@user.id}"
            end

            slim :profile
        else
            redirect "/login"
        end    
   
    end

    get '/logout' do
		session.destroy
		redirect '/login'
    end

end