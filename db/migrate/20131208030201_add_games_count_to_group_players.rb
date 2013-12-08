class AddGamesCountToGroupPlayers < ActiveRecord::Migration
  def change
    add_column :group_players, :games_count, :integer, default: 0
  end
end
