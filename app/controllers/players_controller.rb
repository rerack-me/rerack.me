class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players/1
  # GET /players/1.json
  def show
  end

  require 'will_paginate/array'
  def index
    # calculate_rankings
    @players = Player.order('points DESC')
    @players = @players.reject {|p| p.games_count < 2}
    @players = @players.paginate(page: params[:page], per_page: 25)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find_by(parameterized_username: params[:id])
    end
end
