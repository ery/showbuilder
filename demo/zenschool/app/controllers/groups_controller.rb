class GroupsController < ApplicationController

  def index
    @groups = Group.all
  end

  def new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to @group
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      redirect_to @group
    else
      render 'edit'
    end
  end

  def group_params
    params[:group]
  end

end
