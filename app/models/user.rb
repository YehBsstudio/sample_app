class User < ActiveRecord::Base
	 has_secure_password
	 before_save { email.downcase! } ###原寫法before_save { self.email = email.downcase }
	 validates :name, presence: true, length: {maximum: 50}
	 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	 validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
	 			uniqueness: {case_sensitive:false} 
	 			###如果uniqueness會回傳false 原預設為True

	 has_secure_password
	 validates :password, length: { minimum: 6 }


	 before_create :create_remember_token #在create前先呼叫create_remember_token方法

	 def User.new_remember_token
	 	SecureRandom.urlsafe_base64
	 end

	 def User.encrypt(token) ###加密(註:encrypt 是將...編碼之意)
	 	Digest::SHA1.hexdigest(token.to_s)
	 end

	 private
	 	def create_remember_token
	 		self.remember_token = User.encrypt(User.new_remember_token) ###賦值給User類自身的remember_to
	 	end
end