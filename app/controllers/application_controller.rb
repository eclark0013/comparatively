require './config/environment'

class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        register Sinatra::Flash
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
            redirect "/users/#{session[:user_id]}"
        end
        erb :'/users/create_user'
    end

    post '/signup' do
        @user = User.create(params)
        if @user.errors.messages.any? # redirect for duplicate usernames, no password
            flash[:errors] = @user.errors.messages
            redirect '/signup' 
        else
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
            flash[:errors] = {:password => ["is incorrect"]}
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
            flash[:errors] = @rating.errors.messages
        end

        def edit_rating_for(subject_id)
            @rating = Rating.find_by(subject_id: subject_id, user_id: current_user.id) # uses current_user method to protect data
            if !@rating
                flash[:errors] = {:rating => ["can only be edited by owner"]}
                redirect "/"
            end 
            @rating.score = params[:rating][:score].to_i if params[:rating][:score] != nil
            @rating.review = params[:rating][:review]
            @rating.save
            current_user.update_average_score
            flash[:errors] = @rating.errors.messages
        end

        def redirect_if_not_logged_in(route)
            if !logged_in?
                session[:route] = route
                redirect '/login'
            end
        end

        def find_subject(id)
            @subject = Subject.find_by(id: id)
            if !@subject
                flash[:errors] = {:subject => ["not found"]} 
                redirect "/"
            end 
        end

        def find_user(id)
            @user = User.find_by(id: id)
            if !@user
                flash[:errors] = {:user => ["not found"]} 
                redirect "/"
            end 
        end
        
    end


end