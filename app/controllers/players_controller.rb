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
    @players = Player.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find_by(parameterized_username: params[:id])
    end
end
