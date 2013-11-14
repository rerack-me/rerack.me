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
end
