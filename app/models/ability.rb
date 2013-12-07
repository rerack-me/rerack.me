class Ability
  include CanCan::Ability

  def initialize(player)
    if player
      can :confirm, Game do |game|
        game.losers.include? player
      end

      can :read, Game do |game|
        game.confirmed? or game.players.include? player
      end

      can :destroy, Game do |game|
        (not game.confirmed?) and game.players.include? player
      end

      can :create, Game

      can :confirmations, Game
    end

    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
