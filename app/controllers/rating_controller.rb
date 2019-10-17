require './config/environment'

class RatingController < ApplicationController

    get '/subjects/:id/ratings/new' do
        if !logged_in?
            erb :'/login' 
            # rendering in order to save @subject so that we go to it after login
            # need to make that functional though...
        end
        @subject = Subject.find(params[:id])
        if current_user.subjects.find(@subject.id) # checks if current user has already rated this subject...
            redirect "/subjects/#{@subject.id}/ratings/edit" # ... and if they have, it redirects to edit page 
        else
            erb :'/ratings/new_for_subject' # ... otherwise they can make a new rating for that subject
        end
    end

    post '/subjects/:id/ratings' do
        @rating = Rating.new
        @rating.score = params[:rating][:score].to_i if params[:rating][:score] != nil
        @rating.review = params[:review]
        @rating.user_id = current_user.id
        @rating.subject_id = params[:id]
        @rating.save
        @message = @rating.errors.messages
        binding.pry
        redirect "/subjects/#{params[:id]}"
    end

    get '/subjects/:id/ratings/edit' do
        @subject = Subject.find(params[:id])
        @user = current_user
        if !@user.subjects.find(@subject.id)
            redirect "/subjects/#{@subject.id}/ratings/new"
        else
            @rating = @user.ratings.find_by(subject_id: @subject.id)
            erb :'/ratings/edit'
        end
    end

    patch '/subjects/:id/ratings' do
        edit_rating
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
            @rating = Rating.find_by(subject_id: @subject.id, user_id: current_user.id)
            if !!@rating # if subject exists and you have rated it (edits)
                edit_rating
                binding.pry                    
            else # if subject exists and you have not rated it (new rating for existing subject)
                new_rating
                binding.pry
            end  
        else # subject does not yet exist, therefore must be write-in
            @subject = Subject.new(name: params[:rating][:subject_name], category_id: 1)
            @subject.save
            new_rating
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

    rating_helpers do
        def new_rating
            @rating = Rating.new
            @rating.score = params[:rating][:score].to_i if params[:rating][:score] != nil
            @rating.review = params[:review]
            @rating.user_id = current_user.id
            @rating.subject_id = params[:id]
            @rating.save
            @message = @rating.errors.messages
        end

        def edit_rating
            @rating = Rating.find_by(subject_id: params[:id], user_id: current_user.id)
            @rating.score = params[:rating][:score].to_i if params[:rating][:score] != nil
            @rating.review = params[:rating][:review]
            @rating.save
        end
    end

end