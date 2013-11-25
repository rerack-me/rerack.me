class RemoveConfirmedFromConfirmations < ActiveRecord::Migration
  def change
  	remove_column :confirmations, :confirmed
  end
end
