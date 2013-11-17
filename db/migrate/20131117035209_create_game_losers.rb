class CreateGameLosers < ActiveRecord::Migration
  def change
    create_table :game_losers do |t|
      t.integer :player_id
      t.integer :game_id

      t.timestamps
    end
  end
end
