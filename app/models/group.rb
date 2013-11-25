class Group < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  # players
  has_many :group_players
  has_many :players, through: :group_players, source: 'player'

  def player_usernames=(usernames)
    self.players = Player.where(username: usernames)
  end

  def player_usernames
    self.players.map {|p| p.username}
  end

  def add_player_by_username(username)
    player = Player.find_by(username: username)

    if player.nil? 
      errors.add(:players, "#{username} not found.")
      false
    else
      self.players << player
    end
  end
end
