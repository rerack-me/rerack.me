class PagesController < ApplicationController
  def home
    unless current_player
      redirect_to player_session_path
    end
  end
end
