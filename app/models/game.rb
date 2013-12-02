class Game < ActiveRecord::Base
  after_create :transfer_points

  # winners
  has_many :game_winners
  has_many :winners, :through => :game_winners, :source => "player"

  # losers
  has_many :game_losers
  has_many :losers, :through => :game_losers, :source => "player"

  
  def players
    return winners + losers
  end

  # getting and setting lists of usernames
  def winner_usernames
    return winners.map {|p| p.username}
  end

  def winner_usernames=(usernames)
    @winner_usernames = usernames
    self.winners = Player.where(:username => usernames)
  end
  
  def loser_usernames
    return losers.map {|p| p.username}
  end
  
  def loser_usernames=(usernames)
    @loser_usernames = usernames
    self.losers = Player.where(:username => usernames)
  end

  #returns true if a game has been confirmed by either loser
  def confirmed?
    self.confirmed
  end

  #confirms game
  def confirm
    self.confirmed=true
    self.save
  end

  # validation
  validate :all_users_found
  validate :users_are_unique
 
  validates :winners, length: {is: 2, message: "should have 2 players."}
  validates :losers, length: {is: 2, message: "should have 2 players."}

  def all_users_found
    total_not_found = []

    if @winner_usernames
      total_not_found += @winner_usernames - winner_usernames
    end
    if @loser_usernames
      total_not_found += @loser_usernames - loser_usernames
    end

    if total_not_found.any?
      errors.add(:players, total_not_found.join(", ") + " not found.")
    end
  end

  def users_are_unique
    temp_players = winners + losers
    unless temp_players.count == temp_players.uniq.count
      errors.add(:players, "can't contain duplicates")
    end
  end

  def transfer_points
    winner_ratings = self.winners.map { |winner| winner.points }
    loser_ratings = self.losers.map { |loser| loser.points }

    point_change = Game.point_change(winner_ratings, loser_ratings)

    self.winners.each do |winner|
      winner.points += point_change 
      winner.save
    end

    self.losers.each do |loser|
      loser.points -= point_change 
      loser.save
    end
  end

  def self.point_change(winner_ratings, loser_ratings)
    winners_rating = (winner_ratings[0] + winner_ratings[1])/2
    losers_rating = (loser_ratings[0] + loser_ratings[1])/2

    q_winners = 10**(winners_rating/400)
    q_losers = 10**(losers_rating/400)

    expected_winners = q_winners/(q_winners + q_losers)
    expected_losers = q_losers/(q_winners + q_losers)

    point_change = 32*(1 - expected_winners)
  end
end
