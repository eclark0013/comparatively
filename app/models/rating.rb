class Rating < ActiveRecord::Base
    belongs_to :user
    belongs_to :subject

    def score_difference
        self.score - self.user.average_score
    end

end