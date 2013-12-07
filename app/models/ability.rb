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
      can [:read, :add_player], Group, :id => player.group_ids
      can :create, Group
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
