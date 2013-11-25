class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.string :status
      t.integer :player_id
      t.integer :game_id

      t.timestamps
    end
  end
end
