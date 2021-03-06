DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

Category.new(name: "Book")
users_list = {
    "Tori" => {
        :username => "tori",
        :password => "toripassword"
    },
    "Joey" => {
        :username => "joey",
        :password => "joeypassword"
    },
    "Eric" => {
        :username => "eric",
        :password => "ericpassword"
    },
    "Sheehan" => {
        :username => "sheehan",
        :password => "sheehanpassword"
    },
    "Izzy" => {
        :username => "izzy",
        :password => "izzypassword"
    },
    "Robin" => {
        :username => "robin",
        :password => "robinpassword"
    }
  }

users_list.each do |name, info_hash|
  u = User.new
  info_hash.each do |attribute, value|
      u.send "#{attribute}=", value
  end
  u.save
end

subject_list = {
    "1" => {
        :name => "The Fellowship of the Ring",
        :category_id => 1
    },
    "2" => {
        :name => "Brave New World",
        :category_id => 1
      },
    "3" => {
        :name => "Confessions",
        :category_id => 1
    },
    "4" => {
        :name => "Amusing Ourselves to Death",
        :category_id => 1
    },
    "5" => {
        :name => "Till We Have Faces",
        :category_id => 1
    }
  }

subject_list.each do |number, info_hash|
  s = Subject.new
  info_hash.each do |attribute, value|
      s[attribute] = value
  end
  s.save
end

ratings = {
    "1a" => {
        :score => 3,
        :review => "Meh",
        :user_id => User.find_by(username: User.all[0].username).id,
        :subject_id => 1
    },
    "1b" => {
        :score => 2,
        :review => "awful",
        :user_id => User.find_by(username: User.all[0].username).id,
        :subject_id => 2
    },
    "1c" => {
        :score => 1,
        :review => "terrible",
        :user_id => User.find_by(username: User.all[0].username).id,
        :subject_id => 3
    },
    "1d" => {
        :score => 1,
        :review => "so very bad",
        :user_id => User.find_by(username: User.all[0].username).id,
        :subject_id => 4
    },
    "2a" => {
        :score => 3,
        :review => "Whatever",
        :user_id => User.find_by(username: User.all[1].username).id,
        :subject_id => 2
    },
    "2b" => {
        :score => 5,
        :review => "wow",
        :user_id => User.find_by(username: User.all[1].username).id,
        :subject_id => 5
    },
    "2c" => {
        :score => 4,
        :review => "quite good",
        :user_id => User.find_by(username: User.all[1].username).id,
        :subject_id => 4
    },
    "2d" => {
        :score => 5,
        :review => "amazing",
        :user_id => User.find_by(username: User.all[1].username).id,
        :subject_id => 1
    },
    "3a" => {
        :score => 1,
        :review => "crappy as they all are",
        :user_id => User.find_by(username: User.all[2].username).id,
        :subject_id => 1
    },
    "3b" => {
        :score => 1,
        :review => "crappy as usual",
        :user_id => User.find_by(username: User.all[2].username).id,
        :subject_id => 4
    },
    "3c" => {
        :score => 1,
        :review => "crappy as always",
        :user_id => User.find_by(username: User.all[2].username).id,
        :subject_id => 5
    },
    "3d" => {
        :score => 4,
        :review => "suprisingly decent",
        :user_id => User.find_by(username: User.all[2].username).id,
        :subject_id => 2
    },
    "4a" => {
        :score => 3,
        :review => "okay",
        :user_id => User.find_by(username: User.all[3].username).id,
        :subject_id => 2
    },
    "4b" => {
        :score => 3,
        :review => "alright",
        :user_id => User.find_by(username: User.all[3].username).id,
        :subject_id => 3
    },
    "4c" => {
        :score => 5,
        :review => "very nice",
        :user_id => User.find_by(username: User.all[3].username).id,
        :subject_id => 4
    },
    "4d" => {
        :score => 2,
        :review => "underwhelming",
        :user_id => User.find_by(username: User.all[3].username).id,
        :subject_id => 5
    },
    "5a" => {
        :score => 5,
        :review => "no thanks",
        :user_id => User.find_by(username: User.all[4].username).id,
        :subject_id => 2
    },
    "5b" => {
        :score => 4,
        :review => "okay i get it",
        :user_id => User.find_by(username: User.all[4].username).id,
        :subject_id => 3
    },
    "5c" => {
        :score => 1,
        :review => "bleh",
        :user_id => User.find_by(username: User.all[4].username).id,
        :subject_id => 4
    },
    "5d" => {
        :score => 1,
        :review => "ugh",
        :user_id => User.find_by(username: User.all[4].username).id,
        :subject_id => 1
    },
    "6a" => {
        :score => 3,
        :review => "the usual",
        :user_id => User.find_by(username: User.all[5].username).id,
        :subject_id => 5
    },
    "6b" => {
        :score => 3,
        :review => "as good as can be expected",
        :user_id => User.find_by(username: User.all[5].username).id,
        :subject_id => 3
    },
    "6c" => {
        :score => 3,
        :review => "okayyy",
        :user_id => User.find_by(username: User.all[5].username).id,
        :subject_id => 4
    },
    "6d" => {
        :score => 1,
        :review => "just so bad",
        :user_id => User.find_by(username: User.all[5].username).id,
        :subject_id => 1
    }
  }

ratings.each do |name, info_hash|
    r = Rating.new
    info_hash.each do |attribute, value|
        r[attribute] = value
    end
    r.save
end
