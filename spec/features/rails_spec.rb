require 'spec_helper'

describe "registering" do
  it "should register you and log you in" do
    visit '/'
    click_link 'Sign Up'
    fill_in 'Email', :with => 'test@example.com'
    fill_in 'Password', :with => 'password'
    click_button "Submit"
    current_user.should == 'test@example.com'
  end
end
