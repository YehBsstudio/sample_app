require 'spec_helper'
describe User do 
  
  before do 
  	 @user = User.new(name: "Example User", 
                      email: "user@example.com",
                      password: "foobar",
                      password_confirmation: "foobar") 
  end

  subject { @user }
  it { should respond_to(:name) } ###測試確保該對象之Symbol :name是存在的
  it { should respond_to(:email) }
  it { should respond_to(:password_digest)} ###測試確保users表中有Symbol :password_digest是存在的
  it { should respond_to(:password) } ###同上
  it { should respond_to(:password_confirmation)} ###同上
  it { should be_valid } ###測試確保＠user對象開始時是合法的

  it { should respond_to(:authenticate)} #6.3.3節響應是否有此方法

  describe "when name is not present" do ###[存在性測試]先假定@user.name為空值nil測試@user對象是否是不合法的。
  	before { @user.name = " "} ###指定@user.name為空值nil
  	it { should_not be_valid} ###@user為nil傳入be_valid後回傳為False，should not為 !F -> 輸出True通過測試，否則False 顯示describe描述。 
  end                          ###註：be_valide函式之控制在user_spec.rb內的Validates方法，
                               ###其第一個參數為:name, 第二個參數為presence:true

  describe "when email is not present" do ###同上，若輸出True通過測試，否則False 顯示describe描述。 
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do ###同上，若輸出True通過測試，否則False 顯示describe描述。 
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do ###同上，若輸出True通過測試，否則False 顯示describe描述。 
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                      foo@bar_baz.com foo@bar_baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do ###同上，若輸出True通過測試，否則False 顯示describe描述。 
    it "should be valid" do
      addresses =%w[user@foo.COM A_US-ER@f.b.org first.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase ###賦值給該對象之Symbal :email
      user_with_same_email.save
    end

    it { should_not be_valid}

  end

  describe "when password is not present" do  ###存在性測試
    before do
      @user = User.new(name: "Example User",     ###先假定@user各個symbol之值並作失敗測試
                       email: "user@example.com",
                       password: " ",
                       password_confirmation: " "
                      )
    end
    it { should_not be_valid} ### 測試是否通過
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do ###6.3.3節測試大於6個字符才能通過
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end 

  describe "return value of authenticate method" do ###以下為6.3.3節測試密碼是否正確
    before{@user.save}
    let(:found_user) {User.find_by(email: @user.email)}

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

end