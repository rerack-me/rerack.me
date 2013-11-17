class Game < ActiveRecord::Base

  # winners
  has_many :game_winners
  has_many :winners, :through => :game_winners, :source => "player"

  # losers
  has_many :game_losers
  has_many :losers, :through => :game_losers, :source => "player"
  
  def players
    return winners.merge losers
  end

  # getting and setting lists of usernames
  def winner_usernames
    return winners.map {|p| p.username}
  end

  def winner_usernames=(usernames)
    self.winners = Player.where(:username => usernames)
  end
  
  def loser_usernames
    return losers.map {|p| p.username}
  end
  
  def loser_usernames=(usernames)
    self.losers = Player.where(:username => usernames)
  end

  # validation
  validates :winners, length: {is: 2}
  validates :losers, length: {is: 2}
  validate :users_are_unique

  def users_are_unique
    temp_players = winners + losers
    unless temp_players.count == temp_players.uniq.count
      errors.add(:players, "can't contain duplicates")
    end
  end
end
