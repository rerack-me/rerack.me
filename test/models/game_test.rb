require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "game validation" do
    g = Game.new
    assert !g.save, "Empty game was saved but shouldn't have been able to."
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:a), players(:b)]
    assert !g.save, "Game was saved with duplicate users."
    g.losers = [players(:c), players(:d)]
    assert g.save, "Game with 2 winners and 2 losers didn't save."
  end
  
  test "adding users from usernames" do
    g = Game.new
    g.winner_usernames = ["alice", "bob"]
    g.loser_usernames = ["calvin", "david"]
    assert g.save, "Game with users set from usernames didn't save."

    g_id = g.id

    g = Game.find(g_id)
    assert g.winners.count == 2, 'The winners didnt save!'
    assert g.losers.count == 2, 'The losers didnt save!'
  end

  test "players" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert g.players.map {|p| p.username} == [players(:a), players(:b), players(:c), players(:d)], g.players.map {|p| p.username}
  end

  test "winner_usernames" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save

    assert g.winner_usernames == ["alice", "bob"], "should return winner usernames to be alice and bob"
  end

  test "loser usernames" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save

    assert g.loser_usernames == ["calvin", "david"], "should return loser usernames to be calvin and david"
  end

  test "confirmed?" do

    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.confirmed = true
    g.save

    assert_equal g.confirmed?, true, "game was not confirmed, should have been"
  end

  test "confirm" do

    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    g.confirm

    assert_equal g.confirmed?, true, "game was not confirmed, should have been"
  end

  # test "all users found" do
  # end

  # test "users are unique" do
  # end

  test "transfer points" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).points, 1016, "player a points"
    assert_equal players(:b).points, 1016, "player b points"
    assert_equal players(:c).points, 984, "player c points"
    assert_equal players(:d).points, 984, "player d points"
  end

end
