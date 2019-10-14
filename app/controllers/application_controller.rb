require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  enable :sessions

  get '/' do
    erb :'/login'
  end

  get '/signup' do
    if logged_in?
        @user = User.find(session[:user_id])
        redirect "/users/#{@user.id}"
    end
    erb :'/users/create_user'
  end

  post '/signup' do
    binding.pry
    #create functionality to not allow two users to have the same username
    @user = User.create(params)
    redirect "/users/#{@user.id}"
  end

  get '/users/:id' do
    @user = User.find(params[:id])
    # add a link to make a new rating
    # add a link to see all subjects
    erb :'/users/show_user'
  end

  get '/login' do
    if logged_in?
        @user = User.find(session[:user_id])
        redirect "/users/#{@user.id}"
    else
        erb :'/users/login'
    end
  end

  post '/login' do
    # binding.pry # figure out how to authenticate on login with has_secure_password 
    params
    user = User.find_by(username: params[:username]).authenticate(params[:password])
    if !!user
      session[:user_id] = user.id
      redirect "/users/#{user.id}"
    else
      redirect '/login'
    end
  end

  get '/subjects/:id' do
    @subject = Subject.find(params[:id])
    # add a link to make a new rating (or edit your rating if you have already rated this)
    erb :'/subjects/show_subject'
  end

  helpers do
        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find(session[:user_id])
        end
    end


end