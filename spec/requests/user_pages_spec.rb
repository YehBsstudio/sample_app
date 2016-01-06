require 'spec_helper'

describe "User pages" do

subject {page}

	describe "profile page" do
		# Replace with code to make a user variable before { visit user_path(user) }
  		let(:user){ FactoryGirl.create(:user) }
  		before { visit user_path(user) }

  		it { should have_content(user.name) }
  		it { should have_title(user.name) }
	end
	
	describe "signup page" do ###測試Signup頁面文字部分
		before { visit signup_path }

		it {should have_content('Sign up')}
		it {should have_title(full_title('Sign up'))}
	end

	describe "signup" do	###測試Signup功能部分
		before { visit signup_path } ###造訪頁面signup_path是否連通

		let(:submit){ "Create my account" }	### 以:submit symbol 型態來取代字串	

		describe "with invalid information" do	###測試非法資訊

			describe "after submission" do 		### 測試非法資訊是否正確render 視圖
				before { click_button submit}
				it { should have_title('Sign up')}
				it { should have_content('error')}
			end

			it "should not create a user" do	###測試非法資訊是否沒有成功創造user （user.save ＝false)
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "with valid information" do	###測試填入合法資訊
			before do
				fill_in "Name",				with: "Example User"
				fill_in "Email",			with: "user@example.com"
				fill_in "Password",			with: "foobar"
				fill_in "Confirmation",		with: "foobar"
			end

			it "should create a user" do		###測試新user是否成功創建
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user){ User.find_by(email: 'user@example.com')}

				it { should have_link('Sign out')}
				it { should have_title(user.name)}
				it { should have_selector('div.alert.alert-success', text: 'Welcome')}
			end
		end
	end

end