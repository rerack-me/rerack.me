class Game < ActiveRecord::Base

  # all players that participated in a game
  has_many :game_participations
  has_many :players, :through => :game_participations

  # winners
  has_many :winning_participations, -> {where :is_winner => true}, :class_name => "GameParticipation"
  has_many :winners, :through => :winning_participations, :class_name => "Player", :source => :player

  # losers
  has_many :losing_participations, -> {where :is_winner => false}, :class_name => "GameParticipation"
  has_many :losers, :through => :losing_participations, :class_name => "Player", :source => :player
  
  accepts_nested_attributes_for :game_participations, :winning_participations, :losing_participations

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
  
  <<-COMMENT
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
  COMMENT
end
