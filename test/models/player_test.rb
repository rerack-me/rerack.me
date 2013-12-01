require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "player validations" do
    p = Player.new

    p.username = 'user1'
    assert !p.save, 'Player was saved without email and passwords.'

    p.email = 'test@example.com'
    assert !p.save, 'Player was saved without passwords.'

    p.password = 'passpass'
    p.password_confirmation = 'notpasspass'
    assert !p.save, 'Player was saved with mismatched passwords.'

    p.password_confirmation = 'passpass'
    p.username = ''
    assert !p.save, 'Saved with blank username'

    p.username = 'user1'
    assert p.save!, 'Player was not able to save even with correct information'
  end

  test "username uniqueness" do
    p = Player.new

    p.username = "alice"
    p.email = "test2@example.com"
    p.password = "passpass"
    p.password_confirmation = "passpass"

    assert !p.save, "Saved with duplicate username"
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
end
