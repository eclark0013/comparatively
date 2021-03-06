require './config/environment'

class RatingController < ApplicationController

    get '/subjects/:id/ratings/new' do
        redirect_if_not_logged_in("/subjects/#{params[:id]}/ratings/new")
        find_subject(params[:id])
        if current_user.rated_subject(@subject.id) # checks if current user has already rated this subject...
            redirect "/subjects/#{@subject.id}/ratings/edit" # ... and if they have, it redirects to edit page 
        else
            erb :'/ratings/new_for_subject' # ... otherwise they can make a new rating for that subject
        end
    end

    post '/subjects/:id/ratings' do
        new_rating_for(params[:id])
        if @rating.errors.messages.any?
            redirect "/subjects/#{params[:id]}/ratings/new"
        end
        redirect "/subjects/#{params[:id]}"
    end

    get '/subjects/:id/ratings/edit' do
        redirect_if_not_logged_in("/subjects/#{params[:id]}/ratings/edit")
        find_subject(params[:id])
        @user = current_user
        if current_user.rated_subject(@subject.id)
            @rating = Rating.find_by(subject_id: @subject.id, user_id: current_user.id)
            erb :'/ratings/edit' 
        else
            redirect "/subjects/#{@subject.id}/ratings/new" 
        end  
    end

    patch '/subjects/:id/ratings' do
        edit_rating_for(params[:id])
        redirect "/subjects/#{params[:id]}"
    end


    get '/ratings/new' do
        redirect_if_not_logged_in("/ratings/new")
        @subjects = Subject.all - current_user.subjects
        erb :'/ratings/new'
    end

    get '/ratings/subjects/:subject_id/users/:user_id' do
        find_subject(params[:subject_id])
        find_user(params[:user_id])
        if !!@subject && !!@user
            @rating = Rating.find_by(subject_id: @subject.id, user_id: @user.id)
            if !@rating
                flash[:errors] = {:rating => ["not found"]} 
                redirect "/"
            end
            if @user == current_user
                erb :"/ratings/index_self"
            else
                erb :"/ratings/index"
            end
        else
            flash[:errors] = {:rating => ["does not exist for that subject and user"]}
            redirect "/"
        end
    end

    post '/ratings' do
        @subject = Subject.find_by(name: params[:rating][:subject_name])
        # If new subject input and radio selected, radio selection will override input
        if !!@subject # if the subject already exists
            if current_user.rated_subject(@subject.id)
                edit_rating_for(@subject.id)
                if @rating.errors.messages.any?
                    redirect '/ratings/new' 
                end
            else 
                new_rating_for(@subject.id)
                if @rating.errors.messages.any?
                    redirect '/ratings/new' 
                end     
            end  
        else # if subject does not yet exist (write-in case or blank)
            @subject = Subject.new(name: params[:rating][:subject_name], category_id: 1)
            @subject.save
            if @subject.errors.messages.any? # blank name
                flash[:errors] = @subject.errors.messages
                redirect '/ratings/new' 
            end
            new_rating_for(@subject.id)
        end
        redirect "/subjects/#{@subject.id}"
    end

    delete "/subjects/:id/ratings/delete" do
        @rating = Rating.find_by(subject_id: params[:id], user_id: current_user.id) # uses current_user method to protect data 
        if !!@rating # if rating is not found matching subject and current user, it will not delete
            @rating.delete
            current_user.update_average_score
        end 
        redirect "/users/#{current_user.id}"
    end

end