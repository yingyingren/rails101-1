class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end
  before_action :authenticate_user!, :only => [:new, :create]

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
     redirect_to groups_path
   else
      render :new
   end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent
  end

private

   def group_params
     params.require(:post).permit(:content)
    end

end
