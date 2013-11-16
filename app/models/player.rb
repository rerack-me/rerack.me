class Player < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # all games a user has participated in
  has_many :game_participations
  has_many :games, :through => :game_participations

  # all games a user has won
  has_many :game_wins, -> {where :is_winner => true}, :class_name => "GameParticipation"
  has_many :games_won, :through => :game_wins, :class_name => "Game", :source => :game
  
  # all games a user has lost
  has_many :game_losses, -> {where :is_winner => false}, :class_name => "GameParticipation"
  has_many :games_lost, :through => :game_losses, :class_name => "Game", :source => :game

  accepts_nested_attributes_for :game_participations, :game_wins, :game_losses

#return ranking of player based on algorithm
  def ranking
  end

end
