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

  # all confirmations a player has 
  has_many :confirmations
  has_many :games, :through => :confirmations, :source => :game 
  validates :username, presence: true, uniqueness: true

  #return ranking of player based on algorithm
  def ranking
    Player.where("points > ? AND username != ?", points, self.username).count + 1
  end

  #allows player to confirme game by game_id
  def confirm_game(id)
    game=Game.find(id)
    game.confirmations.each do |confirm|
      confirm.confirmed_game=true
      confirm.save
    end
  end

  #returns all unconfirmed games linked to player
  #would like to find better way to do this
  def unconfirmed_games
    unconfirmed = self.confirmations.where(confirmed_game: false)
    games=Array.new
    unconfirmed.each do |confirmation|
      game= Game.find(confirmation.game_id)
      games.push(game)
    end
    games 
  end

  def confirmed_games
    unconfirmed = self.confirmations.where(confirmed_game: true)
    games=Array.new
    unconfirmed.each do |confirmation|
      game= Game.find(confirmation.game_id)
      games.push(game)
    end
    games
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
