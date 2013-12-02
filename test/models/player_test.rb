require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "player validations" do
    p = FactoryGirl.build(:player, email: nil)
    assert !p.save, 'Player was saved without email.'

    p = FactoryGirl.build(:player, password: 'no matching')
    assert !p.save, 'Player was saved without matching passwords.'

    p = FactoryGirl.build(:player, username: nil)
    assert !p.save, 'Player was saved wihout username.'

    p = FactoryGirl.build(:player, username: '')
    assert !p.save, 'Player was saved with blank username'

    p = FactoryGirl.build(:player)
    assert p.save, 'Player was not able to save even with correct information'
  end

  test "username uniqueness" do
    p = FactoryGirl.build(:player, username: 'alice')

    assert !p.save, "Saved with duplicate username"
  end

  test "email uniqueness" do
    p = Player.new

    p.username = "alice2"
    p.email = "alice@mit.edu"
    p.password = "passpass"
    p.password_confirmation = "passpass"

    assert !p.save, "Saved with duplicate email"
  end

   test "return username" do
    assert_equal players(:a).to_param, "alice"
    assert_equal players(:b).to_param, "bob"
    assert_equal players(:c).to_param, "calvin"
    assert_equal players(:d).to_param, "david"
  end

  test "return games" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).games.count, 1, "player a"
    assert_equal players(:b).games.count, 1, "player b"
    assert_equal players(:c).games.count, 1, "player c"
    assert_equal players(:d).games.count, 1, "player d"
  end

  test "return games_count" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).games_count, 1, "player a"
    assert_equal players(:b).games_count, 1, "player b"
    assert_equal players(:c).games_count, 1, "player c"
    assert_equal players(:d).games_count, 1, "player d"
  end

  test "ranking" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).ranking, 1, "player a"
    assert_equal players(:b).ranking, 1, "player b"
    assert_equal players(:c).ranking, 3, "player c"
    assert_equal players(:d).ranking, 3, "player d"
  end

  test "wins" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).wins.count, 1, "player a"
    assert_equal players(:b).wins.count, 1, "player b"
    assert_equal players(:c).wins.count, 0, "player c"
    assert_equal players(:d).wins.count, 0, "player d"
  end

  test "losses" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).losses.count, 0, "player a"
    assert_equal players(:b).losses.count, 0, "player b"
    assert_equal players(:c).losses.count, 1, "player c"
    assert_equal players(:d).losses.count, 1, "player d"
  end

  test "confirmed games" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).confirmed_games.count, 0, "player a"
    assert_equal players(:b).confirmed_games.count, 0, "player b"
    assert_equal players(:c).confirmed_games.count, 0, "player c"
    assert_equal players(:d).confirmed_games.count, 0, "player d"
  end

  test "unconfirmed games" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).unconfirmed_games.count, 1, "player a"
    assert_equal players(:b).unconfirmed_games.count, 1, "player b"
    assert_equal players(:c).unconfirmed_games.count, 1, "player c"
    assert_equal players(:d).unconfirmed_games.count, 1, "player d"
  end


end
