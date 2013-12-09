# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

first_player = Player.where(username: 'admin').first_or_initialize
first_player.password = 'passpass'
first_player.password_confirmation = 'passpass'
first_player.email = 'admin@rerack.me'
first_player.skip_confirmation!
first_player.skip_reconfirmation!
first_player.save!

global = Group.where(name: 'Global').first_or_initialize
global.admin = first_player
unless global.players.include? first_player
  global.players << first_player
end
global.save

mit = Group.where(name: "MIT").first_or_initialize
mit.admin = first_player
unless mit.players.include? first_player
  mit.players << first_player
end
mit.save