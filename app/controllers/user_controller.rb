require './config/environment'

class UserController < ApplicationController

    get '/users' do
        @users = User.all
        erb :'/users/index'
    end
    
    get '/users/:id' do
        @user = User.find(params[:id])
        # add a link to see all subjects
        if logged_in? && @user == current_user
            erb :'/users/show_self' 
        else
            erb :'/users/show_user'
        end
        
    end

end