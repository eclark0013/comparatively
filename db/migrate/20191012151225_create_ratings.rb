class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :score
      t.string :review
      t.integer :user_id
      t.integer :subject_id
    end
  end
end
