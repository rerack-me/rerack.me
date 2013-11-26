class DropConfirmationsTable < ActiveRecord::Migration
  def up
  	drop_table :confirmations
  end

  def down
  	raise ActiveRecord::IrreversibleMigration 
  end
end
