class Game < ActiveRecord::Base

  #returns true if a game has been confirmed by either loser
  def confirmed?
    self.confirmed
  end

  # checks if points have been transferred, after transfer this is set to true
  # and points won't be transferred again
  @transferred = false

  #confirms game
  def confirm
    self.confirmed=true

    self.groups_in_common.each do |group|
      group.transfer_points self
      group.games << self
    end

    self.save
  end

  ###############################################
  # VALIDATION AND HOOKS                        #
  ###############################################

  # validation
  validate :all_users_found
  validate :users_are_unique
 
  validates :winners, length: {is: 2, message: "should have 2 players."}
  validates :losers, length: {is: 2, message: "should have 2 players."}

  ###############################################
  # GROUPS                                      #
  ###############################################

  has_many :group_games
  has_many :groups, through: :group_games, source: 'group'

  ###############################################
  # PLAYERS                                     #
  ###############################################

  # winners
  has_many :game_winners
  has_many :winners, :through => :game_winners, :source => "player"

  # losers
  has_many :game_losers
  has_many :losers, :through => :game_losers, :source => "player"

  
  def players
    return winners + losers
  end

  # getting and setting lists of usernames
  def winner_usernames
    return winners.map {|p| p.username}
  end

  # winner usernames and loser usernames need to both be valid on time of save
  def winner_usernames=(usernames)
    @winner_usernames = usernames
    self.winners = Player.where(:username => usernames)
  end
  
  def loser_usernames
    return losers.map {|p| p.username}
  end
  
  def loser_usernames=(usernames)
    @loser_usernames = usernames
    self.losers = Player.where(:username => usernames)
  end

  def self.point_change(winner_ratings, loser_ratings)
    winners_rating = winner_ratings.sum/winner_ratings.count
    losers_rating = loser_ratings.sum/loser_ratings.count

    q_winners = 10**(winners_rating/400)
    q_losers = 10**(losers_rating/400)

    expected_winners = q_winners/(q_winners + q_losers)

    return 32*(1 - expected_winners)
  end

  def groups_in_common
    groups = self.winners[0].groups
    groups = self.winners[1].groups & groups
    groups = self.losers[0].groups & groups
    groups = self.losers[1].groups & groups
    
    groups
  end

  private
    def all_users_found
      total_not_found = []

      if @winner_usernames
        total_not_found += @winner_usernames - winner_usernames
      end
      if @loser_usernames
        total_not_found += @loser_usernames - loser_usernames
      end

      if total_not_found.any?
        errors.add(:players, total_not_found.join(", ") + " not found.")
      end
    end

    def users_are_unique
      temp_players = winners + losers
      unless temp_players.count == temp_players.uniq.count
        errors.add(:players, "can't contain duplicates")
      end
    end
end
