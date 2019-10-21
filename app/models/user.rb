class User < ActiveRecord::Base

    has_secure_password  
    has_many :ratings
    has_many :subjects, through: :ratings
    validates :username, presence: true
    validates :username, uniqueness: true

    def average_score
        @average_score ||= (self.ratings.average(:score)).round(2)
    end
    
    def update_average_score
        @average_score = (self.ratings.average(:score)).round(2)
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
  