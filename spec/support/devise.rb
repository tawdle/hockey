RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end

def sign_in_as_admin
  @user = FactoryGirl.create(:admin)
  sign_in(@user)
end
