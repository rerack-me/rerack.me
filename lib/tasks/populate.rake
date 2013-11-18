namespace :db do
  desc "Create some sample data"
  task populate: :environment do

    p = Player.new
    p.username = 'admin'
    p.email = 'admin@gmail.com'
    p.password = 'passpass'
    p.password_confirmation = 'passpass'
    p.skip_confirmation!
    p.save!


    25.times do |n|    
      p = Player.new
      p.username = Faker::Name.name
      p.email = Faker::Internet.email
      p.password = 'passpass'
      p.password_confirmation = 'passpass'
      p.skip_confirmation!
      p.save!
    end

    50.times do |n|
      g = Game.new
      players = Player.order("RANDOM()")[0,4]
      g.winners = players[2,2]
      g.losers = players[0,2]

      g.save!
    end
  end
end
