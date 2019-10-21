require './config/environment'

class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "secret"
    end


    get '/' do
        if !logged_in?
            erb :'/users/login'
        else
            @subjects = Subject.all
            @users = User.all
            erb :'/index'
        end
    end

    get '/signup' do
        if logged_in?
            @user = User.find(session[:user_id])
            redirect "/users/#{@user.id}"
        end
        erb :'/users/create_user'
    end

    post '/signup' do
        if !!User.find_by(username: params[:username])
            redirect '/signup' # protects against duplicate usernames; create functionality to write in an error message?
        else
            @user = User.create(params)
            session[:user_id] = @user.id
            if !!(session[:route]) #coming from an attempt to access another route
                @route = session[:route]
                session.delete("route")
                redirect "#{@route}"
            else
                redirect "/users/#{@user.id}"
            end
        end
    end

    get '/login' do
        if logged_in?
            @user = current_user
            redirect "/users/#{@user.id}"
        else
            erb :'/users/login'
        end
    end

    post '/login' do
        @user = User.find_by(username: params[:username])
        if !!@user && !!@user.authenticate(params[:password])
            session[:user_id] = @user.id
            if !!(session[:route]) #coming from an attempt to access another route
                @route = session[:route]
                session.delete("route")
                redirect "#{@route}"
            else
                redirect "/users/#{@user.id}"
            end
        else
            redirect '/login'
        end
    end

    get '/logout' do
        session[:user_id] = nil
        redirect '/login'
    end

    helpers do
        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find(session[:user_id])
        end

        def new_rating_for(subject_id)
            @rating = Rating.new
            @rating.score = params[:rating][:score].to_i if params[:rating][:score] != nil
            @rating.review = params[:rating][:review]
            @rating.user_id = current_user.id
            @rating.subject_id = subject_id
            @rating.save
            current_user.update_average_score
            session[:errors] = @rating.errors.messages
        end

        def edit_rating_for(subject_id)
            @rating = Rating.find_by(subject_id: subject_id, user_id: current_user.id) # uses current_user method to protect data
            @rating.score = params[:rating][:score].to_i if params[:rating][:score] != nil
            @rating.review = params[:rating][:review]
            @rating.save
            current_user.update_average_score
            session[:errors] = @rating.errors.messages
        end
        
    end


end