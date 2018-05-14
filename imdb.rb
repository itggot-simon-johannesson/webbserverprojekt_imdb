class Imdb < Sinatra::Base

    enable :sessions
    register Sinatra::Flash

    before do
        blacklist_login = ['/login', '/signup']
        blacklist = ['/user/:id']

        if blacklist.include?(request.path)
            redirect "/login" 
        end

        if params[:id]
            if blacklist_login.include?(request.path)
                redirect "/user/#{params[:id]}"
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
        redirect "/login"
    end
    
    get '/login' do
        slim :login
    end

    post '/login' do
        @user = User.login(params)
        if @user
            session[:id] = @user.id
            redirect "/"
        else
            flash[:error] = 'incorrect username or password'
            redirect "/login"
        end      

    end

    get '/user/:id' do
        p @user
        slim :profile
    end

    get '/logout' do
		session.destroy
		redirect '/login'
    end

    post '/search' do
        @search = params[:search]
        
        redirect "/search?search=#{@search}&films=yes&users=yes&stars=yes"
    end

    post '/filter' do

        @filters = [params[:films], params[:users], params[:stars]]
        
        @filters.each_with_index do |filter, i|
            if filter == nil
                @filters.delete_at(i)
                @filters.insert(i, "no")
            else
                @filters.delete_at(i)
                @filters.insert(i, "yes")
            end
        end

        p @search = params[:search]

        redirect "/search?search=#{@search}&films=#{@filters[0]}&users=#{@filters[1]}&stars=#{@filters[2]}"
    end

    get '/search' do
        @search = params[:search]
        @film_filter = params[:films]
        @user_filter = params[:users]
        @star_filter = params[:stars]
        

        @films = Films.info_by_title("%" + @search + "%")
        @users = Users.info_by_username("%" + @search + "%")

        @search_page = true

        slim :search
    end



    get '/film/:id' do
        @film_id = params['id'].to_i



        slim :film
    end

end