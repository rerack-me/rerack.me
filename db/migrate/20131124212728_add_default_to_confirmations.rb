class AddDefaultToConfirmations < ActiveRecord::Migration
  def up
  	change_column_default :confirmations, :status, "UNCONFIRMED"
  end

  def down
  	change_column_default :confirmations, :status , nil
  end

end
