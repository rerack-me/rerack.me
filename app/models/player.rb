class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessor :login

  def to_param
    return username
  end

  def games
    return wins + losses
  end

  def games_count
    return wins.count + losses.count
  end

  # all games a user has won
  has_many :game_winners
  has_many :wins, :through => :game_winners, :source => :game
  
  # all games a user has lost
  has_many :game_losers
  has_many :losses, :through => :game_losers, :source => :game

  # groups
  has_many :group_players
  has_many :groups, through: :group_players, source: :group

  validates :username, presence: true, uniqueness: true

  #return ranking of player based on algorithm
  def ranking
    Player.where("points > ? AND username != ?", points, self.username).count + 1
  end

  def games_in_group(group)
    group_wins = wins.filter {|win| all_players_in_group(win, group)}
    group_losses = losses.filter {|loss| all_players_in_group(loss, group)}
    return group_wins + group_losses
  end

  #returns all games associated with player
  def games
    self.wins + self.losses
  end

  #returns all confirmed games
  def confirmed_games
    self.wins.where(confirmed: true) + self.losses.where(confirmed: true)
  end

  #return all unconfirmed games
  def unconfirmed_games
    self.wins.where(confirmed: false) + self.losses.where(confirmed: false)
  end


  #override will allow for loggin in with email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

private
  def all_players_in_group(game, group)
    group_winners = winners & group.players
    group_losers = losers & group.players
    if group_winners.count != 2 or group_losers.count != 2
      false
    else
      true
    end
  end
end
