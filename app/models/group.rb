class Group < ActiveRecord::Base
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  # players
  has_many :group_players
  has_many :players, through: :group_players, source: 'player'

  after_save :calculate_player_rankings
  after_update :calculate_player_rankings

  def player_usernames
    self.players.map {|p| p.username}
  end

  def games
    group_games = Game.all.select {|game| game_in_group?(game, self)}
    return group_games.sort {|a,b| b.created_at <=> a.created_at}
  end

  # recalculate the score of all players in the group
  def calculate_player_rankings
    self.group_players.each { |p| p.points = 1000; p.save; }

    self.games.each do |game|
      group_game_winners = game.winners.map {|winner| self.group_players.find_by(player_id: winner.id)}
      group_game_losers = game.losers.map {|loser| self.group_players.find_by(player_id: loser.id)}

      winner_ratings = group_game_winners.map {|g| g.points }
      loser_ratings = group_game_losers.map {|g| g.points }

      point_change = Game.point_change(winner_ratings, loser_ratings)
      
      group_game_winners.each do |winner|
        winner.points += point_change
        winner.save
      end
      group_game_losers.each do |loser|
        loser.points -= point_change
        winner.save
      end
    end
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

end
