require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    setup_players_and_global
  end

  test "player validations" do
    p = FactoryGirl.build(:player, email: nil)
    assert !p.save, 'Player was saved without email.'


    p = FactoryGirl.build(:player, password: 'no matching')
    assert !p.save, 'Player was saved without matching passwords.'

    p = FactoryGirl.build(:player, username: nil)
    assert !p.save, 'Player was saved wihout username.'

    p = FactoryGirl.build(:player, username: '')
    assert !p.save, 'Player was saved with blank username'

    p = FactoryGirl.build(:player, username: 'alice')
    assert !p.save, "Saved with duplicate username"

    FactoryGirl.create(:player, email: 'test@email.com')
    p = FactoryGirl.build(:player, email: 'test@email.com')
    assert !p.save, "Saved with duplicate email"
  end

  test "to param is username" do
    assert_equal "alice", @a.to_param
    assert_equal "bob", @b.to_param
    assert_equal "calvin", @c.to_param
    assert_equal "david", @d.to_param
  end

  test "return games_count" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.save

    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @e]
    g.save

    assert_equal 2, @a.games_count
    assert_equal 2, @b.games_count
    assert_equal 2, @c.games_count
    assert_equal 1, @d.games_count
    assert_equal 1, @e.games_count
  end

  test "parameterized username uniqueness" do
    p = FactoryGirl.build(:player, username: 'a.b')
    assert p.save
    assert_equal 'a-b', p.parameterized_username

    p = FactoryGirl.build(:player, username: 'a-b')
    p.update_parameterized_username
    assert !p.save, 'Saved with duplicate parameterized username'
  end

  test "update parameterized username" do 
    USERNAMES = ["a.b", "alex-_"]
    PARAMETERIZED_USERNAMES = USERNAMES.map {|s| s.parameterize}

    p = FactoryGirl.create(:player, username: USERNAMES[0])
    assert p.parameterized_username == PARAMETERIZED_USERNAMES[0]

    p = Player.find_by(username: USERNAMES[0])
    p.username = USERNAMES[1]
    p.save!

    assert p.parameterized_username != PARAMETERIZED_USERNAMES[0],
      "Parameterized username not changed"
    assert p.parameterized_username == PARAMETERIZED_USERNAMES[1],
      "Parameterized username not set to new value"
  end

  test "update ranking after games" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    assert g.save!

    assert_equal 1, @a.rank
    assert_equal 1, @b.rank
    assert_equal 1, @c.rank
    assert_equal 1, @d.rank

    g.confirm

    # ranking updated after confirm
    assert_equal 1, @a.rank
    assert_equal 1, @b.rank
    assert_equal 3, @e.rank
    assert_equal 4, @c.rank
    assert_equal 4, @d.rank
  end

  test "count wins and losses" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.save

    assert_equal 1, @a.wins.count
    assert_equal 1, @b.wins.count
    assert_equal 0, @c.wins.count
    assert_equal 0, @d.wins.count

    assert_equal 0, @a.losses.count
    assert_equal 0, @b.losses.count
    assert_equal 1, @c.losses.count
    assert_equal 1, @d.losses.count
  end

  test "count confirmed and unconfirmed games" do
    g = Game.new
    g.winners = [@a, @b]
    g.losers = [@c, @d]
    g.save

    assert_equal 0, @a.confirmed_games.count
    assert_equal 0, @b.confirmed_games.count
    assert_equal 0, @c.confirmed_games.count
    assert_equal 0, @d.confirmed_games.count

    assert_equal 1, @a.unconfirmed_games.count
    assert_equal 1, @b.unconfirmed_games.count
    assert_equal 1, @c.unconfirmed_games.count
    assert_equal 1, @d.unconfirmed_games.count
  end
end
