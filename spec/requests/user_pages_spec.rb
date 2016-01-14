require 'spec_helper'

describe "User pages" do

subject {page}
	
	describe "index" do ###9.3.3 分頁測試
    	let(:user) { FactoryGirl.create(:user) }
    	before(:each) do
			sign_in user
      		visit users_path
    	end
    	
    	it { should have_title('All users') }
    	it { should have_content('All users') }
    
    	describe "pagination" do
      		before(:all) { 30.times { FactoryGirl.create(:user) } }
      		after(:all)  { User.delete_all }
      		it { should have_selector('div.pagination') }
      		it "should list each user" do
        		User.paginate(page: 1).each do |user|
          		expect(page).to have_selector('li', text: user.name)
        		end
			end 
		end

		
		describe "delete links" do ###9.43 測試刪除用戶功能
			
			it { should_not have_link('delete')}
			
			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin)}
				before do
					sign_in admin
					visit users_path
				end

				it { should have_link('delete', href: user_path(User.first))}
				it  "should be able to delete another user" do
					expect do 
						click_link('delete', match: :first)
					end.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin))}
			end
		end
	end
	


	describe "index" do ###9.3.1
		before do
      		sign_in FactoryGirl.create(:user)
      		FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      		FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      		visit users_path
    	end
    	
    	it { should have_title('All users') }
    	it { should have_content('All users') }
    	
    	it "should list each user" do
      		User.all.each do |user|
        	expect(page).to have_selector('li', text: user.name)
      		end
		end 
	end

	describe "profile page" do
		# Replace with code to make a user variable before { visit user_path(user) }
  		let(:user){ FactoryGirl.create(:user) }
  		let!(:m1){ FactoryGirl.create(:micropost, user: user, content: "Foo")} ###創建m1 微博 內容為"Foo"
  		let!(:m2){ FactoryGirl.create(:micropost, user: user, content: "Bar")} ###同上

  		before { visit user_path(user) }

  		it { should have_content(user.name) }
  		it { should have_title(user.name) }

  		describe "microposts" do	###檢查microposts微博內是否含有內容與確定數量是否正確
  			it { should have_content(m1.content) }						
  			it { should have_content(m2.content) }
  			it { should have_content(user.microposts.count) }
  		end

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

	describe "edit" do ###9.1 用戶編輯頁面測試
		let(:user){ FactoryGirl.create(:user) }
		before do 
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_content("Update your profile") }
			it { should have_title("Edit user") }
			it { should have_link('change', href: 'http://gravatar.com/emails') }
		end

		describe "with invalid information" do  
			before { click_button "Save changes" }

			it { should have_content('error')}
		end

		describe "with valid information" do ###9.1.3 編輯成功測試
			let(:new_name)  { "New Name" }
    		let(:new_email) { "new@example.com" }
    		before do
        		fill_in "Name", 			with: new_name
        		fill_in "Email",			with: new_email
        		fill_in "Password",			with: user.password
        		fill_in "Confirm Password", with: user.password
        		click_button "Save changes"
			end
      		it { should have_title(new_name) }
      		it { should have_selector('div.alert.alert-success') }
      		it { should have_link('Sign out', href: signout_path) }
      		specify { expect(user.reload.name).to  eq new_name }
      		specify { expect(user.reload.email).to eq new_email }
		end
	end

end