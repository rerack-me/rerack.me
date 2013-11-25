class AddConfirmationToGames < ActiveRecord::Migration
  def change
  	add_column :games, :confirmed, :boolean, default: false
  end
end
