class Rating < ActiveRecord::Base
    belongs_to :user
    belongs_to :subject
    validates :score, presence: true
    validates :subject_id, presence: true

    def score_difference
        self.score - self.user.average_score
    end

end
