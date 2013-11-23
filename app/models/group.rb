class Group < ActiveRecord::Base
  validates :name, presence: true

  # players
  has_many :group_players
  has_many :players, through: :group_players, source: 'player'

end
