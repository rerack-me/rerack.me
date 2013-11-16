require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "player validations" do
    p = Player.new
    
    p.username = 'user1'
    assert !p.save, 'Player was saved without email and passwords.'

    p.email = 'test@gmail.com'
    assert !p.save, 'Player was saved without passwords.'

    p.password = 'passpass'
    p.password_confirmation = 'notpasspass'
    assert !p.save, 'Player was saved with mismatched passwords.'

    p.password_confirmation = 'passpass'
    p.username = ''
    assert !p.save, 'Saved with blank username'

    p.username = 'user1'
    assert p.save, 'Player was not able to save even with correct information'
  end
end
