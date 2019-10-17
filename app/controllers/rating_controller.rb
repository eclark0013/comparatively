require './config/environment'

class RatingController < ApplicationController

    get '/subjects/:id/ratings/new' do
        if !logged_in?
            erb :'/login' 
                # make a method that renders login and then redirects back to original desired path
        end
        @subject = Subject.find(params[:id])
        if current_user.rated_subject(@subject.id) # checks if current user has already rated this subject...
            redirect "/subjects/#{@subject.id}/ratings/edit" # ... and if they have, it redirects to edit page 
        else
            erb :'/ratings/new_for_subject' # ... otherwise they can make a new rating for that subject
        end
    end

    post '/subjects/:id/ratings' do
        new_rating_for(params[:id])
        redirect "/subjects/#{params[:id]}"
    end

    get '/subjects/:id/ratings/edit' do
        if !logged_in?
            erb :'/login' 
            # make a method that renders login and then redirects back to original desired path
        end
        @subject = Subject.find(params[:id])
        @user = current_user
        if current_user.rated_subject(@subject.id) # checks if current user has already rated this subject...
            @rating = Rating.find_by(subject_id: @subject.id, user_id: current_user.id)
            erb :'/ratings/edit' # ... and if they have, it opens the edit page 
        else
            redirect "/subjects/#{@subject.id}/ratings/edit" # ... otherwise redirects to a new rating for that subject
        end
    end

    patch '/subjects/:id/ratings' do
        edit_rating_for(params[:id])
        redirect "/subjects/#{params[:id]}"
    end


    get '/ratings/new' do
        @subjects = Subject.all - current_user.subjects
        if !logged_in?
            erb :'/login' 
            # rendering in order to save @subject so that we go to it after login
            # need to make that functional though...
        else
            erb :'/ratings/new'
        end
    end

    post '/ratings' do
        @subject = Subject.find_by(name: params[:rating][:subject_name])
        # If new subject input and radio selected, radio selection will override input
        if !!@subject # if the subject already exists
            if current_user.rated_subject(@subject.id) # if subject exists and you have rated it (edits)
                edit_rating_for(@subject.id)
                binding.pry                    
            else # if subject exists and you have not rated it (new rating for existing subject)
                new_rating_for(@subject.id)
                binding.pry
            end  
        else # subject does not yet exist, therefore must be write-in
            @subject = Subject.new(name: params[:rating][:subject_name], category_id: 1)
            @subject.save
            new_rating_for(@subject.id)
            binding.pry
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