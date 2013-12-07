module PlayersHelper
  def goto_path(player)
    "/players?goto=#{player.username}"
  end
end
