require 'spec_helper'

describe "a tic-tac-toe board and plays a game" do

  before(:each) do
    visit('/')
  end

  context "home page", :js => true do
    it "should prompt you who plays first" do
      find("#ttt").text.should == "Who d"+"o you want to play first?"
    end
  end

  context "human first", :js => true do
    before(:each) do
      click_button("Human First")
    end
    it "should show board" do
      find("#t-0")
    end
    it "should warn about invalid move" do
      page.evaluate_script("make_move(0)")
      page.evaluate_script("make_move(0)")
      find("#message").text.should == "Please click on an empty square"
    end
    it "should show no message with valid moves" do
      page.evaluate_script("make_move(1)")
      page.evaluate_script("make_move(4)")
      page.evaluate_script("make_move(2)")
      page.evaluate_script("make_move(8)")
      find("#message").text.should == ""
    end
    it "should show no message when human wins" do
      page.evaluate_script("position = init_position('x x x" +
                                                     "x o o" +
                                                     "- - o', 'o')")
      page.evaluate_script("check_for_win()")
      find("#message").text.should == "Human Wins"
    end
  end
end
      # # @javascript
      # # Scenario:
      # #   When I click on button "Human First"
      # #   And I reload the page
      # #   Then I should have selector "#t-0"
