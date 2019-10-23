require './config/environment'

class SubjectController < ApplicationController

    get '/subjects' do
        @subjects = Subject.all
        erb :'/subjects/index'
    end
    
    get '/subjects/:id' do
        find_subject(params[:id])
        erb :'/subjects/show_subject'
    end


end