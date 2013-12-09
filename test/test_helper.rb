ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...

  def setup_players_and_global
    g = Group.new name: 'Global'
    g.admin = FactoryGirl.create(:player)
    g.save!

    @a = FactoryGirl.create(:player, username: 'alice')
    @b = FactoryGirl.create(:player, username: 'bob')
    @c = FactoryGirl.create(:player, username: 'calvin')
    @d = FactoryGirl.create(:player, username: 'david')
    @e = FactoryGirl.create(:player, username: 'ernie')
  end
end
