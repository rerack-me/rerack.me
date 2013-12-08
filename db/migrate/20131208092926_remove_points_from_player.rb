class RemovePointsFromPlayer < ActiveRecord::Migration
  def change
    remove_column :players, :points
  end
end
