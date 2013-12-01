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

  test "players"
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal g.players.count, 4, "Should have returned that there are 4 players in a game"

  end

  test "winner_usernames"
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save

    assert g.winner_usernames == ["alice", "bob"], "should return winner usernames to be alice and bob"
  end

  test "loser usernames"
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save

    assert g.loser_usernames == ["calvin", "david"], "should return loser usernames to be calvin and david"
  end

  test "confirmed?"

    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.confirmed = true
    g.save

    assert_equal g.confirmed?, true, "game was not confirmed, should have been"
  end

  test "confirm"

    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    g.confirm

    assert_equal g.confirmed?, true, "game was not confirmed, should have been"
  end

  test "all users found"
  end

  test "users are unique"
  end

  test "transfer points"
end

end
