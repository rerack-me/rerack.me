class Ability
  include CanCan::Ability

  def initialize(player)
    if player
      # games
      can :confirm, Game do |game|
        game.losers.include? player
      end

      can :read, Game do |game|
        game.confirmed? or game.players.include? player
      end

      can :destroy, Game do |game|
        (not game.confirmed?) and game.players.include? player
      end

      can [:create, :confirmations], Game

      # groups
      can :create, Group
      can [:read, :add_player], Group, :id => player.group_ids
      cannot :add_player, Group, :name => "Global"

      can [:update, :destroy], Group, :admin_id => player.id
    end

    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
