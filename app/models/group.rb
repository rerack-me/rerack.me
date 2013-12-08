class Group < ActiveRecord::Base

  ###############################################
  # VALIDATION AND HOOKS                        #
  ###############################################

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  def self.global
    Group.find_by(name: 'Global')
  end

  ###############################################
  # IMAGES                                      #
  ###############################################

  has_attached_file :image, :styles => {:full_width => "1170x200#", :thumb => "400x70#"}

  ###############################################
  # PLAYERS                                     #
  ###############################################

  # players
  has_many :group_players
  has_many :players, through: :group_players, source: 'player'

  belongs_to :admin, class_name: "Player", foreign_key: "admin_id"

  def player_usernames
    self.players.map {|p| p.username}
  end

  def add_player_by_username(username)
    player = Player.find_by(username: username)

    if player.nil? 
      errors.add(:players, "#{username} not found.")
      false
    elsif self.player_usernames.include? username
      errors.add(:players, "#{username} already in group.")
      false
    else
      self.players << player
    end
  end

  def ranked_players
    return players.sort {|a,b| b.points_in(self) <=> a.points_in(self) }
  end

  ###############################################
  # GAMES                                       #
  ###############################################

  has_many :group_games
  has_many :games, through: :group_games, source: 'game'

  # transfers points for group players in a game
  def transfer_points(game)
    group_game_winners = game.winners.map {|winner| self.group_players.find_by(player_id: winner.id)}
    group_game_losers = game.losers.map {|loser| self.group_players.find_by(player_id: loser.id)}

    winner_ratings = group_game_winners.map {|g| g.points }
    loser_ratings = group_game_losers.map {|g| g.points }

    point_change = Game.point_change(winner_ratings, loser_ratings)
    
    group_game_winners.each do |winner|
      winner.points += point_change
      winner.games_count += 1
      winner.save
    end
    group_game_losers.each do |loser|
      loser.points -= point_change
      loser.games_count += 1
      loser.save
    end
  end
end
