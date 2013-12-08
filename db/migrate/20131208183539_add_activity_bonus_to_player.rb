class AddActivityBonusToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :activity_bonus, :float
  end
end
