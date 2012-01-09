class UsersController < ApplicationController

    before_filter :authenticate, :except => [:show, :new, :create]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => [:destroy]

  def index
	@title = "All Users"
	@users = User.paginate(:page => params[:page])
  end

  def show 
    @user = User.find(params[:id])
	@title = @user.name
	@microposts = @user.microposts.paginate(:page => params[:page])
  end

  def following
	@title = "Following"
	@user = User.find(params[:id])
	@users = @user.following.paginate(:page => params[:page])
	render 'show_follow'
  end
 
  def followers
	@title = "Followers"
	@user = User.find(params[:id])
	@users = @user.followers.paginate(:page => params[:page])
	render 'show_follow'
  end
  
  def new
    @title = "Sign Up"
	@user = User.new
  end
 
  def create
		#raise params[:user].inspect
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			redirect_to @user, :flash => {:success => "Welcome to the Sample App!"}
		else
	    @title = "Sign Up"
			render 'new'
		end
  end

  def edit
		@user = User.find(params[:id])
		@title = "Edit User"
  end

  def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			redirect_to @user, :flash => {:success => "Profile Updated."}
		else
			@title = "Edit User"
			render 'edit'
		end
  end

  def destroy
		User.find(params[:id]).destroy
		redirect_to users_path, :flash => {:success => "User destroyed."}
  end

  private

  	def authenticate
			deny_access unless signed_in?
		end
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			user = User.find(params[:id])
			redirect_to(root_path) unless (current_user.admin? && !current_user?(user))
		end

end
