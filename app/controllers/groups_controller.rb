class GroupsController < ApplicationController
  before_filter :set_group, only: []

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
  end

  private
    def group_params
      params.require(:group).permit(player_usernames: [])
    end

    def set_group
      @group = Group.find(params[:id])
    end
end 
