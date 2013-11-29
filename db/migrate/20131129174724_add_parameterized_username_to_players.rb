class AddParameterizedUsernameToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :parameterized_username, :string
  end
end
