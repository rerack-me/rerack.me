module GamesHelper
  def today(games)
    games.select {|g| g.created_at > 1.day.ago}
  end

  def this_week(games)
    games.select {|g| g.created_at >= 1.week.ago and g.created_at <= 1.day.ago}
  end

  def before_this_week(games)
    games.select {|g| g.created_at < 1.week.ago}
  end
end
