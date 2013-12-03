require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "rankings not updated if players not in group" do
    g = FactoryGirl.create(:group)

    a = FactoryGirl.create(:player)
    b = FactoryGirl.create(:player)
    c = FactoryGirl.create(:player)
    d = FactoryGirl.create(:player)

    g.players << [a, b, c]
    g.save

    assert g.players.include?(a), 'Group does not include player.'

    game = Game.new
    game.winners << [a, b]
    game.losers << [c, d]
    game.confirm
    game.save!

    assert a.group_points(g) == 1000.0, 'Player group rating updated'
  end

  test "rankings should be updated if players in group" do
    g = FactoryGirl.create(:group)

    a = FactoryGirl.create(:player)
    b = FactoryGirl.create(:player)
    c = FactoryGirl.create(:player)
    d = FactoryGirl.create(:player)

    g.players << [a, b, c, d]
    g.save

    assert g.players.include?(a), 'Group does not include player.'

    game = Game.new
    game.winners << [a, b]
    game.losers << [c, d]
    game.confirm
    game.save!

    assert a.group_points(g) > 1000.0, 'Player group rating not improved'
    assert c.group_points(g) < 1000.0, 'Player group rating not decreased'
  end  
end
