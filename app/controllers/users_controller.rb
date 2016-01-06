class UsersController < ApplicationController
  
  def new
  	@user = User.new ###從模型Model中使用User類 並創建給實例instance @user 
  end
  
  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		sign_in @user
  		flash[:success] = "Welcome to the Sample APP!"
  		redirect_to @user
      #Handle a successful save
  	else
  		render 'new'
  	end
  end

  private
  	def user_params
    	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

end