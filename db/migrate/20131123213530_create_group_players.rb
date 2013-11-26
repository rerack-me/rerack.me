class CreateGroupPlayers < ActiveRecord::Migration
  def change
    create_table :group_players do |t|
      t.integer :player_id
      t.integer :group_id

      t.integer :points

      t.timestamps
    end
  end
end
