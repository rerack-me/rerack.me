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
end
