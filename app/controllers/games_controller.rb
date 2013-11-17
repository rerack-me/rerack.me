class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all.order('created_at DESC')
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      update_points(@game)
      if @game.save
        format.html { redirect_to games_path, notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:winner_usernames => [], :loser_usernames => [])
    end

    def update_points(game)
      winners = game.winners
      losers = game.losers

      winners_rating = (winners[0].points + winners[1].points)/2
      losers_rating = (losers[0].points + losers[1].points)/2

      q_winners = 10**(winners_rating/400)
      q_losers = 10**(losers_rating/400)

      expected_winners = q_winners/(q_winners + q_losers)
      expected_losers = q_losers/(q_winners + q_losers)

      point_change = 32*(1 - expected_winners)

      winners.each do |winner|
        winner.points += point_change
        winner.save
      end

      losers.each do |loser|
        loser.points -= point_change
        loser.save
      end
    end
end
