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
end
