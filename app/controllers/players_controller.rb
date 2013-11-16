class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players/1
  # GET /players/1.json
  def show
  end

  def index
    @players = Player.all
    respond_to do |format|
      format.json {
        render json: @players.map { |player| player.username }
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end
end
