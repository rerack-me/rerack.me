require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    g = Group.new name: 'Global'
    g.save

    @a = FactoryGirl.create(:player)
    @b = FactoryGirl.create(:player)
    @c = FactoryGirl.create(:player)
    @d = FactoryGirl.create(:player)
  end

  test "add_player_by_username" do
    gr=Group.new
    gr.add_player_by_username("alice")
    assert  gr.players[0].username == "alice", "gr.add_player_by_username failed. did not add alice to the group"
    assert !gr.add_player_by_username("alice"), "gr.add_player_by_username failed. Player was added twice to the group"
    assert !gr.add_player_by_username("eunice"), "gr.add_player_by_username failed. Invalid player was added to the group"
  end

  test "player_usernames" do
    gr = Group.new
    gr.add_player_by_username("alice")
    gr.add_player_by_username("bob")
    assert gr.player_usernames == ["alice", "bob"], "gr.player_usernames failed. did not return proper usernames alice and bob"
    gr.add_player_by_username("calvin")
    assert gr.player_usernames == ["alice", "bob", "calvin"], "gr.player_usernames failed. did not return proper usernames alice and bob and calvin"
    gr.add_player_by_username("eunice")
    assert gr.player_usernames == ["alice", "bob", "calvin"], "gr.player_usernames failed. did not return proper usernames alice and bob and calvin after adding fake player eunice"
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
