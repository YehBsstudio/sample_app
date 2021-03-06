class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update] 
  before_action :admin_user,     only: [:destroy]
  

  def new
  	@user = User.new ###從模型Model中使用User類 並創建給實例instance @user 
  end

  def edit 
  end

  def index
    #@users = User.all 
    @users = User.paginate(page: params[:page])
  end
  
  def show ###show 方法會將實例變量 @傳入show圖中
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		sign_in (@user) ###函式若僅單一參數可將()可省略
  		flash[:success] = "Welcome to the Sample APP!"
  		redirect_to @user
      #Handle a successful save
  	else
  		render 'new'
  	end
  end

  def update
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end 
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_url
  end

  private
  	
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end