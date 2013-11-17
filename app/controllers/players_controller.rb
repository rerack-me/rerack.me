class PlayersController < ApplicationController
  before_action :set_player, only: [:show]

  # GET /players/1
  # GET /players/1.json
  def show
  end

  def index
    # calculate_rankings
    @players = Player.all.order('points DESC')
    respond_to do |format|
      format.json {
        render json: @players.map { |player| player.username }
      }
      format.html {
        render 'index'
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # def calculate_rankings
    #   Player.all.each { |player| player.points = 1000; player.save }

    #   Game.all.order('created_at asc').each do |game|
    #     winners = game.winners
    #     losers = game.losers

    #     winners_rating = (winners[0].points + winners[1].points)/2
    #     losers_rating = (losers[0].points + losers[1].points)/2

    #     q_winners = 10**(winners_rating/400)
    #     q_losers = 10**(losers_rating/400)

    #     expected_winners = q_winners/(q_winners + q_losers)
    #     expected_losers = q_losers/(q_winners + q_losers)

    #     point_change = 32*(1 - expected_winners)

    #     winners.each do |winner|
    #       winner.points += point_change
    #       winner.save
    #     end

    #     losers.each do |loser|
    #       loser.points -= point_change
    #       loser.save
    #     end
    #   end
    # end
end
