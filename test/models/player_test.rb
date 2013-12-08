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

    assert_equal "alice", players(:a).to_param
    assert_equal "bob", players(:b).to_param
    assert_equal "calvin", players(:c).to_param
    assert_equal "david", players(:d).to_param
  end

  test "activity bonus" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.created_at = 5.day.ago 
    g.save
    assert_equal players(:a).activity_bonus, 0.0, "Player A received activity bonus before confirmation"
    g.confirm
    assert g.confirmed? == true, "game was not confirmed"
    assert_equal players(:a).activity_bonus, 3.2, players(:a).games.select{|game| game.created_at > 1.month.ago}.select{|game| game.confirmed? == true}.count
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

  test "parameterized username uniqueness" do
    p = Player.new
    p.username = "a.b"
    p.email = "test2@example.com"
    p.password = "passpass"
    p.password_confirmation = "passpass"
    p.save!

    assert p.parameterized_username == 'a-b'

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

    assert_equal 1, @a.rank
    assert_equal 1, @b.rank
    assert_equal 1, @c.rank
    assert_equal 1, @d.rank

    g1.confirm
    g2.confirm

    # ranking updated after confirm
    assert_equal 1, @a.rank
    assert_equal 1, @b.rank
    assert_equal 3, @c.rank
    assert_equal 3, @d.rank
  end

  test "wins" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).wins.count, 1
    assert_equal players(:b).wins.count, 1
    assert_equal players(:c).wins.count, 0
    assert_equal players(:d).wins.count, 0
  end

  test "losses" do
    g = Game.new
    g.winners = [players(:a), players(:b)]
    g.losers = [players(:c), players(:d)]
    g.save
    assert_equal players(:a).losses.count, 0
    assert_equal players(:b).losses.count, 0
    assert_equal players(:c).losses.count, 1
    assert_equal players(:d).losses.count, 1
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
