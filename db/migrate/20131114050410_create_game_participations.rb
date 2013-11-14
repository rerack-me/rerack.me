class CreateGameParticipations < ActiveRecord::Migration
  def change
    create_table :game_participations do |t|
      t.integer :player_id
      t.integer :game_id
      t.boolean :is_winner

      t.timestamps
    end
  end
end
