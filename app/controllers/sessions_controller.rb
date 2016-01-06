class SessionsController < ApplicationController
##(生成符合REST架構的路由關係)
	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			sign_in user
			redirect_to user
			#Sign the user in and redirect to the user's show page.
		else 
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
			#create an error message and re-render the signin form.
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

end	