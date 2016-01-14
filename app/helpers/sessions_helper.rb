module SessionsHelper ###已將include SessionsHelper提昇至ApplicationController類中給各個控制器引用方法(8.2.1章)
	def sign_in(user) ###此處user 是屬於User類的一個實例instance變數 並非Hash或symbol!
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user ###將self的用法是將user類的一個實例（此處為user) 傳入類別方法"current_user"內 
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

  	def current_user
    	remember_token = User.encrypt(cookies[:remember_token])
    	@current_user ||= User.find_by(remember_token: remember_token)
  	end

 	def current_user?(user)
    	user == current_user
	end


    def signed_in_user
      unless signed_in? ###9.2.3 友好轉向
        store_location
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
      end
    end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def redirect_back_or(default) ###9.2.3 友好轉向
    	redirect_to(session[:return_to] || default)
    	session.delete(:return_to)
	end
  
  	def store_location ###9.2.3 友好轉向
    	session[:return_to] = request.fullpath
	end
end