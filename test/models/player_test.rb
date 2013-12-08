require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    g = Group.create name: 'Global'

    @a = FactoryGirl.create(:player)
    @b = FactoryGirl.create(:player)
    @c = FactoryGirl.create(:player)
    @d = FactoryGirl.create(:player)
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
    players(:a).save!
    players(:b).save!
    players(:c).save!
    players(:d).save!

    assert_equal "alice", players(:a).to_param, "Player A did not parameterize as alice"
    assert_equal "bob", players(:b).to_param,  "Player B did not paramterize as bob"
    assert_equal "calvin", players(:c).to_param, "Player C did not paramterize as calvin"
    assert_equal "david", players(:d).to_param,  "Player D did not paramterize as david"
  end

  test "activity bonus" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.created_at = 5.day.ago 
    g.save
    assert_equal 0.0, players(:a).activity_bonus, "Player A received activity bonus before confirmation"
    g.confirm
    assert g.confirmed?, "game was not confirmed"
    assert_equal 3.2 players(:a).activity_bonus, players(:a).games.select{|game| game.created_at > 1.month.ago}.select{|game| game.confirmed? == true}.count
end


  test "return games" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).games.count, 1, "player a did not return 1 game"
    assert_equal players(:b).games.count, 1, "player b did not return 1 game"
    assert_equal players(:c).games.count, 1, "player c did not return 1 game"
    assert_equal players(:d).games.count, 1, "player d did not return 1 game"
  end

  test "return games_count" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).games_count, 1, "player a did not return 1 game count"
    assert_equal players(:b).games_count, 1, "player b did not return 1 game count"
    assert_equal players(:c).games_count, 1, "player c did not return 1 game count"
    assert_equal players(:d).games_count, 1, "player d did not return 1 game count"
  end

  test "parameterized username uniqueness" do
    p = Player.new
    p.username = "a.b"
    p.email = "test2@example.com"
    p.password = "passpass"
    p.password_confirmation = "passpass"
    p.save!

    assert p.parameterized_username == 'a-b', "did not parameterize to a-b"

    p = Player.new
    p.username = "a-b"
    p.email = "test2@example.com"
    p.password = "passpass"
    p.password_confirmation = "passpass"
    assert !p.save, 'Saved with duplicate parameterized username'
  end

  test "update parameterized username" do 
    USERNAMES = ["a.b", "alex-_"]
    PARAMETERIZED_USERNAMES = USERNAMES.map {|s| s.parameterize}

    p = Player.new
    p.username = USERNAMES[0]
    p.email = "test2@example.com"
    p.password = "passpass"
    p.password_confirmation = "passpass"
    p.save

    assert p.parameterized_username == PARAMETERIZED_USERNAMES[0]

    p = Player.find_by(username: USERNAMES[0])
    p.username = USERNAMES[1]
    p.save!

    assert p.parameterized_username != PARAMETERIZED_USERNAMES[0],
      "Parameterized username not changed"
    assert p.parameterized_username == PARAMETERIZED_USERNAMES[1],
      "Parameterized username not set to new value"
  end

  test "ranking" do
    g1 = Game.new
    g1.winners = [@a, @b]
    g1.losers = [@c, @d]
    g1.save!
    
    g2 = Game.new
    g2.winners << [@a, @b] 
    g2.losers << [@c, @d]
    g2.save!

    assert_equal 1, @a.rank, "player a ranking did not return 1 before games confirmed"
    assert_equal 1, @b.rank, "player b ranking did not return 1 before games confirmed"
    assert_equal 1, @c.rank, "player c ranking did not return 1 before games confirmed"
    assert_equal 1, @d.rank, "player d ranking did not return 1 before games confirmed"

    g1.confirm
    g2.confirm

    # ranking updated after confirm
    assert_equal 1, @a.rank, "player a ranking did not retun 1 after games confirmed"
    assert_equal 1, @b.rank, "player b ranking did not return 1 after games confirmed"
    assert_equal 3, @c.rank, "player c ranking did not return 3 after games confirmed"
    assert_equal 3, @d.rank, "player d ranking did not return 3 after games confirmeed"
  end

  test "wins" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal 1, players(:a).wins.count, "player a wins did not update to 1"
    assert_equal 1, players(:b).wins.count, "player b wins did not update to 1"
    assert_equal 0, players(:c).wins.count, "player c wins not 0"
    assert_equal 0, players(:d).wins.count, "player d wins not 0"
  end

  test "losses" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal 0,  players(:a).losses.count, "player a losses not zero"
    assert_equal 0, players(:b).losses.count, "player b losses not zero"
    assert_equal 1, players(:c).losses.count, "player c losses did not update"
    assert_equal 1, players(:d).losses.count, "player d losses did not update"
  end

  test "confirmed games" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal 0, players(:a).confirmed_games.count, "player a improperly confirmed games"
    assert_equal 0, players(:b).confirmed_games.count, "player b improperly confirmed games"
    assert_equal 0, players(:c).confirmed_games.count, "player c improperly confirmed games"
    assert_equal 0, players(:d).confirmed_games.count, "player d improperly confirmed games"
  end

  test "unconfirmed games" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal 1,  players(:a).unconfirmed_games.count, "player a does not have 1 unconfirmed game"
    assert_equal 1, players(:b).unconfirmed_games.count, "player b does not have 1 unconfirmed game"
    assert_equal 1, players(:c).unconfirmed_games.count, "player c does not have 1 unconfirmed game"
    assert_equal 1, players(:d).unconfirmed_games.count, "player d does not have 1 unconfirmed game"
  end
end
