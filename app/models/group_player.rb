class GroupPlayer < ActiveRecord::Base
  belongs_to :group
  belongs_to :player

  def username
    player.username
  end

  def ranking
    group_players = GroupPlayer.where("group_id == ?  AND points > ?", 
      group.id, self.points)
    group_players.count + 1
  end

  def to_param
    player.to_param
  end
end
