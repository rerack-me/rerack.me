class GroupsController < ApplicationController
  before_filter :set_group, only: [:show, :update, :edit, :add_player]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_path(@group) }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_player
    username = params[:username]

    respond_to do |format|
      if @group.add_player_by_username(username)
        format.html { redirect_to @group, notice: 'Player successfully added to group.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: 'Group was successfully updated.'  
    else
      render action: 'edit' 
    end
  end

  private
    def group_params
      params.require(:group).permit(:name)
    end

    def set_group
      @group = Group.find(params[:id])
    end
end 
