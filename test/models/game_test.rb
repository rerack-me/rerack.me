require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    g = Group.new name: 'Global'
    g.admin = players(:a)
    g.save!

    @a = FactoryGirl.create(:player)
    @b = FactoryGirl.create(:player)
    @c = FactoryGirl.create(:player)
    @d = FactoryGirl.create(:player)
  end

  test "game validation: all users found and users are unique" do
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

    g = Game.find(g.id)
    assert g.winners.count == 2, 'The winners didnt save!'
    assert g.losers.count == 2, 'The losers didnt save!'
  end

  test "winner_usernames" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save

    assert g.winner_usernames == ["alice", "bob"], "Game did not return winner usernames to be alice and bob"
  end

  test "loser usernames" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save

    assert g.loser_usernames == ["calvin", "david"], "Game did not return loser usernames to be calvin and david"
  end

  test "confirmed?" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.confirm
    g.save

    assert_equal g.confirmed?, true, "Game did not return as confirmed; g.confirmed? failed."
  end

  test "confirm" do
    g = Game.new

    g.winners << [@a, @b]
    g.losers << [@c, @d]
    g.save
    g.confirm

    assert_equal g.confirmed?, true, "Game did not return as confirmed; g.confirm failed."
  end

  test "do not transfer points without confirm" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.save

    assert_equal 1000.0, @a.points, "Player A's points transfered before confirmation"
    assert_equal 1000.0, @b.points, "Player B's points transfered before confirmation"
    assert_equal 1000.0, @c.points, "Player C's points transfered before confirmation"
    assert_equal 1000.0, @d.points, "Player D's points transfered before confirmation"
  end

  test "transfer points after confirm" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.save

    g.confirm

    assert_equal 1019.2 @a.points, "Player A's points did not return as 1019.2 after first win"
    assert_equal 1019.2 @b.points, "Player B's points did not return as 1019.2 after first win"
    assert_equal 987.2 @c.points, "Player C's points did not return as 987.2 after first loss"
    assert_equal 987.2 @d.points, "Player D's points did not return as 987.2 after first loss"
  end

end
