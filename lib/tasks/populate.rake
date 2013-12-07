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
      p.username = Faker::Name.first_name
      p.email = Faker::Internet.email
      p.password = 'passpass'
      p.password_confirmation = 'passpass'
      p.skip_confirmation!
      p.save
    end

    # create groups
    10.times do |n|
      g = Group.new
      g.name = Faker::Name.last_name
      players = Player.order("RANDOM()")[0,10]
      g.admin = players.first
      g.players << players
      g.save
    end

    # this way I can generate games for myself automatically
    p = Player.new
    p.username = "sashko"
    p.email = "sashko@mit.edu"
    p.password = "asdfasdf"
    p.password_confirmation = "asdfasdf"
    p.skip_confirmation!
    p.save

    # create games
    70.times do |n|
      g = Game.new
      players = Player.order("RANDOM()")[0,4]
      g.winners = players[2,2]
      g.losers = players[0,2]
      g.created_at = Time.now - rand(1..10000).minutes

      if rand > 0.25 # make most of the games pre-confirmed
        g.confirmed = true
      end

      g.save
    end
  end
end
