class SetDefaultPointsValueForPlayers < ActiveRecord::Migration
  def change
    change_column :players, :points, :float, :default => 1000.0
  end
end
