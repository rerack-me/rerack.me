include ActionView::Helpers::GroupsHelper

class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessor :login

  after_save :update_parameterized_username
  after_update :update_parameterized_username

  validates_format_of :username, with: /\A[A-Za-z0-9_.\-]+\Z/

  def update_parameterized_username
    self.parameterized_username = self.username.parameterize
  end

  def to_param
    self.parameterized_username
  end

  def games
    all_games = wins + losses
    return all_games.sort {|a,b| b.created_at <=> a.created_at}
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
    group_wins = wins.filter {|win| game_in_group?(win, group)}
    group_losses = losses.filter {|loss| game_in_group?(loss, group)}
    return group_wins + group_losses
  end

  #returns all confirmed games
  def confirmed_games
    confirmed = self.wins.where(confirmed: true) + self.losses.where(confirmed: true)
    return confirmed.sort {|a,b| b.created_at <=> a.created_at}
  end

  #return all unconfirmed games
  def unconfirmed_games
    unconfirmed = self.wins.where(confirmed: false) + self.losses.where(confirmed: false)
    return unconfirmed.sort {|a,b| a.created_at <=> b.created_at}
  end

  def group_rating(group)
    group_player = GroupPlayer.find_by(player_id: self.id)
    group_player.points
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
