namespace :db do
  desc "Create some sample"
  task populate: :environment do

    10.times do |n|    
      p = Player.new
      p.username = "Player#{n}"
      p.email = "player_#{n}@gmail.com"
      p.password = 'passpass'
      p.password_confirmation = 'passpass'
      p.skip_confirmation!
      p.save!
    end

    # 99.times do |n|
    #   name = Faker::Name.name
    #   email = "example-#{n+1}@gmail.com"
    #   password = "passpass"
    #   User.create!(name: name, email: email,
    #             password: password, password_confirmation: password)
    # end
    # users = User.all(limit: 6)
    # 50.times do
    #   body = Faker::Lorem.sentence(5)
    #   users.each { |user| user.posts.create!(body: body) }
    # end
  end
end
