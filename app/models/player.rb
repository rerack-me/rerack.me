class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  def games
    return wins.merge losses
  end

  # all games a user has won
  has_many :game_winners
  has_many :wins, :through => :game_winners, :source => :player
  
  # all games a user has lost
  has_many :game_losers
  has_many :losses, :through => :game_losers, :source => :player

  validates :username, presence: true, uniqueness: true

  #return ranking of player based on algorithm
  def ranking
  end

end
