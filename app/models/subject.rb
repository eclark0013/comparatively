class Subject < ActiveRecord::Base
    belongs_to :category
    has_many :ratings
    has_many :users, through: :ratings
    validates :name, presence: true

    def raw_score # a raw average of all scores for the subject
        self.ratings.average(:score)
    end

    def comp_score # an average of all differences
        differences = self.ratings.collect do |rating|
            rating.score_difference
        end

        sum = 0
        differences.each do |difference|
            sum += difference
        end
        (sum.to_f/ratings.size).round(2)
    end

end