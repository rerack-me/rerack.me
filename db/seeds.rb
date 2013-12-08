# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

first_player = Player.new(username: 'admin', 
                              password: 'passpass', 
                              password_confirmation: 'passpass', 
                              email: 'admin@rerack.com')
first_player.skip_confirmation!
first_player.save!
global = Group.create(name: 'Global', admin: first_player)

global.players << first_player