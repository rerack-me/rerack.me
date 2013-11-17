class AddPointsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :points, :float
    add_index :players, :points
  end
end
