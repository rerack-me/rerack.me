class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessor :login

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

  #override will allow for loggin in with email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end
