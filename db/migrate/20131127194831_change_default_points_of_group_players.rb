class ChangeDefaultPointsOfGroupPlayers < ActiveRecord::Migration
  def change
    change_column :group_players, :points, :float, :default => 1000.0
  end
end
