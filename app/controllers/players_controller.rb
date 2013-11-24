class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players/1
  # GET /players/1.json
  def show
  end

  def index
    # calculate_rankings
    @players = Player.all.order('points DESC')
    
    @players = @players.reject {|player| player.games_count < 2}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end
end
