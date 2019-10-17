class User < ActiveRecord::Base
    # attr_accessor :average_score (could make it so that it doesn't calculate too often)
    
    has_secure_password  
    has_many :ratings
    has_many :subjects, through: :ratings
    

    def average_score # an average of all scores given by that user
        (self.ratings.average(:score)).round(2)
    end

    def rated_subject(id)
        begin
            self.subjects.find(id)
        rescue
            false
        else
            true
        end
    end

end
  