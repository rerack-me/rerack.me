class Group < ActiveRecord::Base
  validates :name, presence: true

  # players
  has_many :group_players
  has_many :players, through: :group_players, source: 'player'

  def player_usernames=(usernames)
    @player_usernames = usernames
    self.players = Player.where(username: usernames)
  end

  def player_usernames
    self.players.map {|p| p.username}
  end
end
