class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessor :login

  self.per_page = 25

  before_save :update_parameterized_username
  before_update :update_parameterized_username

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
    players = Player.where("points > ? AND username != ?", points, self.username)
    players = players.select { |p| p.is_ranked? }
    players.count + 1
  end

  def is_ranked?
    self.games_count >= 2
  end

  def games_in_group(group)
    group_wins = wins.filter {|win| all_players_in_group(win, group)}
    group_losses = losses.filter {|loss| all_players_in_group(loss, group)}
    group_games group_wins + group_losses
    return group_games.sort {|a,b| b.created_at <=> a.created_at}
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

  def games_to_confirm
    return self.losses.where(confirmed: false).order("created_at DESC")
  end

  def group_points(group)
    group.save
    group_player = GroupPlayer.find_by_player_id_and_group_id(self.id, group.id)
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
