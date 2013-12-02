module GroupsHelper
  def game_in_group?(game, group)
    group_winners = game.winners & group.players
    group_losers = game.losers & group.players
    if group_winners.count != 2 or group_losers.count != 2
      false
    else
      true
    end
  end
end
