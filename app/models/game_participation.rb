class GameParticipation < ActiveRecord::Base
  belongs_to :player
  belongs_to :game

  def username
  	self.player.email if self.player
  end

  def username=(user)
  	player = Player.find_by(username: user)
  	self.player_id = player.id 
  end

end
