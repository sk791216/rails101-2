class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :join ,:quit]
  before_action :find_group_and_permission, only: [:edit, :update, :destroy]
  def index
    @group = Group.all

  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      current_user.join!(@group)
      redirect_to groups_path ,notice: "Create success!"
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update success!"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path , notice: "Delete success"
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入群組成功!"
    else
      flash[:warning] = "你已經是本群組成員!"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:notice] = "退出成功!"
    else
      flash[:warning] = "非本群組成員，不需退出!"
    end
    redirect_to group_path(@group)
  end

  private

  def group_params
    params.require(:group).permit(:title, :description)
  end

  def find_group_and_permission
    @group = Group.find(params[:id])
    if current_user!=@group.user
      redirect_to root_path, alert: "You have no permission."
    end
  end
end
