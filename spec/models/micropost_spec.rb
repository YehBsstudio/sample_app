require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  	before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  	
  	subject { @micropost }
  	
  	it { should respond_to(:content) }
  	it { should respond_to(:user_id) }
  	it { should respond_to(:user) }
  	its(:user) { should eq user } ### == it { expect (@micropost.user).eq_to user } //此處 :user 指的是此實例@micropost的symbol :user （方法） 
  	
  	it { should be_valid }
  	
  	describe "when user_id is not present" do
    	before { @micropost.user_id = nil }
    	it { should_not be_valid }
	  end 

    describe "when user_id is not present" do  ###測試Micropost的數據驗證 10.1.5節
      before { @micropost.user_id = nil }
      it { should_not be_valid }
    end
   
    describe "with blank content" do
      before { @micropost.content = " " }
      it { should_not be_valid }
    end
   
    describe "with content that is too long" do
      before { @micropost.content = "a" * 141 }
      it { should_not be_valid }
    end                                       ###10.1.5 節 end
end