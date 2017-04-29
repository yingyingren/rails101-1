class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]

  def index
    @groups = Group.all
  end

 def new
   @group = Group.find(params[:group_id])
   @post = Post.new
 end

 def create
   @group = Group.find(params[:group_id])
   @post = Post.new(post_params)
   @post.group = @group
   @post.user = current_user

   if @group.save
     current_user.join!(@group)
     redirect_to groups_path
   else
      render :new
   end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def destroy
    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
  end

  def edit
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def update
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission."
    end

    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render :edit
    end
  end


  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本讨论版成功！"
    else
      flash[:waring] = "你已经是本讨论版成员了！"
    end
    redirect_to groups_path(@group)
    end

    def quit
      @group = Group.find(params[:id])

      if current_user.is_member_of?(@group)
        current_user.quit!(@group)
        flash[:alert] = "已经退出本讨论版！"
      else
        flash[:warning] = "你不是本讨论版成员，怎么退出xd"
      end

      redirect_to groups_path(@group)
  end


private

  def group_params
    params.require(:group).permit(:title, :description)
  end

end
