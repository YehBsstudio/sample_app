require 'spec_helper'
describe "Micropost pages" do ### 對創建微博功能的測試
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "micropost creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      
    	it "should not create a micropost" do ###測試是否在invalid 狀態下create micropost
        	expect { click_button "Post" }.not_to change(Micropost, :count)
    	end
      	
      	describe "error messages" do	###測試是否在invalid 狀態下 按下button 發出 error訊息
        	before { click_button "Post" }
        	it { should have_content('error') }
		    end 
	  end
    
    describe "with valid information" do
		before { fill_in 'micropost_content', with: "Lorem ipsum" }
      	
      	it "should create a micropost" do ###測試是否在 valid狀態下, 按下post後資料庫(Micopost.count == 1)
        	expect { click_button "Post" }.to change(Micropost, :count).by(1)
      	end
	  end 

    describe "micropost destruction" do ###針對Microposts控制器destroy動作的測試 (10.3.4節)
      before { FactoryGirl.create(:micropost, user: user) }
      
      describe "as correct user" do
        before { visit root_path }
        it "should delete a micropost" do
          expect { click_link "delete" }.to change(Micropost, :count).by(-1)
        end 
      end
    end
  end
end