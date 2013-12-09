require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    setup_players_and_global
  end

  test "add player to group by username" do
    gr = FactoryGirl.create(:group)

    gr.add_player_by_username(@a.username)
    assert  gr.players.include? @a

    assert !gr.add_player_by_username(@a.username), 'added duplicate username'
    assert !gr.add_player_by_username('not a username'), 'added non-existant user'
  end

  test "player usernames for group" do
    gr = FactoryGirl.create(:group)

    gr.add_player_by_username(@a.username)
    gr.add_player_by_username(@b.username)
    assert_equal [@a.username, @b.username], gr.player_usernames

    gr.add_player_by_username("not a username")
    assert_equal [@a.username, @b.username], gr.player_usernames
  end

  test "rankings not updated if players not in group" do
    g = FactoryGirl.create(:group)

    g.players << [@a, @b, @c]
    g.save

    assert g.players.include?(@a), 'Group does not include player.'
    assert !g.players.include?(@d), "Group includes player it shouldn't"

    game = Game.new
    game.winners << [@a, @b]
    game.losers << [@c, @d]
    game.confirm
    game.save!

    assert @a.points_in(g) == 1000.0, 'Player group rating updated'
  end

  test "rankings should be updated if players in group" do
    g = FactoryGirl.create(:group)

    g.players << [@a, @b, @c, @d]
    g.save

    assert g.players.include?(@a), 'Group does not include player.'

    game = Game.new
    game.winners << [@a, @b]
    game.losers << [@c, @d]
    game.confirm
    game.save!

    assert @a.points_in(g) > 1000.0, 'Player group rating not improved'
    assert @c.points_in(g) < 1000.0, 'Player group rating not decreased'
  end
end
