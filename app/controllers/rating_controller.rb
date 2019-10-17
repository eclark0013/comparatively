require './config/environment'

class RatingController < ApplicationController

    get '/subjects/:id/ratings/new' do
        if !logged_in?
            session[:route] = "/subjects/#{params[:id]}/ratings/new"
            erb :'/users/login' 
        else
            @subject = Subject.find(params[:id])
            if current_user.rated_subject(@subject.id) # checks if current user has already rated this subject...
                redirect "/subjects/#{@subject.id}/ratings/edit" # ... and if they have, it redirects to edit page 
            else
                erb :'/ratings/new_for_subject' # ... otherwise they can make a new rating for that subject
            end
        end
    end

    post '/subjects/:id/ratings' do
        new_rating_for(params[:id])
        redirect "/subjects/#{params[:id]}"
    end

    get '/subjects/:id/ratings/edit' do
        if !logged_in?
            session[:route] = "/subjects/#{params[:id]}/ratings/edit"
            erb :'/users/login'
        else
            @subject = Subject.find(params[:id])
            @user = current_user
            if current_user.rated_subject(@subject.id)
                @rating = Rating.find_by(subject_id: @subject.id, user_id: current_user.id)
                erb :'/ratings/edit' 
            else
                redirect "/subjects/#{@subject.id}/ratings/new" 
            end 
        end  
    end

    patch '/subjects/:id/ratings' do
        edit_rating_for(params[:id])
        redirect "/subjects/#{params[:id]}"
    end


    get '/ratings/new' do
        if !logged_in?
            session[:route] = "/ratings/new"
            erb :'/users/login' 
        else
            @subjects = Subject.all - current_user.subjects
            erb :'/ratings/new'
        end
    end

    post '/ratings' do
        @subject = Subject.find_by(name: params[:rating][:subject_name])
        # If new subject input and radio selected, radio selection will override input
        if !!@subject # if the subject already exists
            if current_user.rated_subject(@subject.id)
                edit_rating_for(@subject.id)
            else 
                new_rating_for(@subject.id)
            end  
        else # if subject does not yet exist (write-in case)
            @subject = Subject.new(name: params[:rating][:subject_name], category_id: 1)
            @subject.save
            new_rating_for(@subject.id)
        end
        redirect "/subjects/#{@subject.id}"
    end

    delete "/subjects/:id/ratings/delete" do
        @rating = Rating.find_by(subject_id: params[:id], user_id: current_user.id)
        if !!@rating # in case user tried to go to direct url for delete rating for a subject they haven't rated
            @rating.delete
        end 
        redirect "/users/#{current_user.id}"
    end

end