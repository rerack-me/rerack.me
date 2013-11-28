module GamesHelper
  def point_change(winner_ratings, loser_ratings)
    winners_rating = (winner_ratings[0] + winner_ratings[1])/2
    losers_rating = (loser_ratings[0] + loser_ratings[1])/2

    q_winners = 10**(winners_rating/400)
    q_losers = 10**(losers_rating/400)

    expected_winners = q_winners/(q_winners + q_losers)
    expected_losers = q_losers/(q_winners + q_losers)

    point_change = 32*(1 - expected_winners)
  end
end
