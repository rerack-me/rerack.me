class ChangeConfirmationsStatusToConfirmed < ActiveRecord::Migration
  def change
  	remove_column :confirmations, :status, :string
  	add_column :confirmations, :confirmed, :boolean, default: false
  	add_column :confirmations, :confirmed_game, :boolean, default: false
  end
end
