class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players/1
  # GET /players/1.json
  def show
    @shared_groups = @player.groups.where(current_ability.model_adapter(Group, :show).conditions)
  end

  # GET /players
  require 'will_paginate/array'
  def index
    # calculate_rankings
    @players = Player.order('points DESC')
    @players = @players.select {|p| p.is_ranked?}

    # set the page
    # page overwrites goto, if specified
    # if we want to goto a user, choose their page
    if params[:page].blank? and params[:goto].present?
      player = Player.find_by_username(params[:goto])
      # goto player not found or not included in rankings
      if player.blank? or !@players.include? player
        flash[:notice] = "Could not find #{params[:goto]} in the rankings."
        page = params[:page]
      else
        # add 1 because pages aren't 0 indexed
        index = @players.find_index(player)
        page = index/Player.per_page + 1
      end  
    else
      page = params[:page]
    end  

    @players = @players.paginate(page: page, per_page: Player.per_page)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find_by(parameterized_username: params[:id])
    end
end
