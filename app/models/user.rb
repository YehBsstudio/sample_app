class User < ActiveRecord::Base
	 before_save { email.downcase! } ###原寫法before_save { self.email = email.downcase }
	 validates :name, presence: true, length: {maximum: 50}
	 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	 validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
	 			uniqueness: {case_sensitive:false} 
	 			###如果uniqueness會回傳false 原預設為True

	 has_secure_password
	 validates :password, length: { minimum: 6 }
end