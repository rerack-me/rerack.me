require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "add_player_by_username" do 
  	gr=Group.new
  	gr.add_player_by_username("alice")
  	assert	gr.players[0].username == "alice", "gr.add_player_by_username failed. did not add alice to the group"
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

end
