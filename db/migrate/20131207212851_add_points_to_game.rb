class AddPointsToGame < ActiveRecord::Migration
  def change
    add_column :games, :points, :float, default: 0
  end
end
