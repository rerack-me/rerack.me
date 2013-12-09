require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    setup_players_and_global
  end

  test "game validation: all users found and users are unique" do
    g = Game.new
    assert !g.save, "Empty game was saved but shouldn't have been able to."
    
    g.winners = [@a, @b]
    g.losers = [@b, @d]
    assert !g.save, "Game was saved with duplicate users."
    
    g.losers = [@c, @d]
    assert g.save, "Game with 2 winners and 2 losers didn't save."
    assert_equal g.players, g.winners + g.losers
  end

  test "adding users from usernames" do
    g = Game.new
    g.winner_usernames = ["alice", "bob"]
    g.loser_usernames = ["calvin", "david"]
    assert g.save, "Game with users set from usernames didn't save."

    g = Game.find(g.id)
    assert_equal 2, g.winners.count
    assert_equal 2, g.losers.count
  end

  test "winner and loser usernames" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.save

    assert_equal ["alice", "bob"], g.winner_usernames
    assert_equal ["calvin", "david"], g.loser_usernames
  end

  test "confirm game" do
    g = Game.new

    g.winners << [@a, @b]
    g.losers << [@c, @d]
    g.save
    g.confirm

    assert g.confirmed?
  end

  test "do not transfer points without confirm" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.save

    assert_equal 1000, @a.points
    assert_equal 1000, @b.points
    assert_equal 1000, @c.points 
    assert_equal 1000, @d.points
  end

  test "transfer points after confirm" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.save

    g.confirm

    assert_equal @a.points, 1016, "Player A's points did not return as 1016 after first win"
    assert_equal @b.points, 1016, "Player B's points did not return as 1016 after first win"
    assert_equal @c.points, 984, "Player C's points did not return as 984 after first loss"
    assert_equal @d.points, 984, "Player D's points did not return as 984 after first loss"
  end
end
