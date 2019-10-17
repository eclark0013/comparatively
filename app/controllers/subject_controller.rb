require './config/environment'

class SubjectController < ApplicationController

    get '/subjects' do
        @subjects = Subject.all
        erb :'/subjects/index'
    end
    
    get '/subjects/:id' do
        @subject = Subject.find(params[:id])
        # add a link to make a new rating (or edit your rating if you have already rated this)
        erb :'/subjects/show_subject'
    end


end