require 'spec_helper'

describe "Ttts" do
  describe "GET /ttts" do
    it "sanity check", :js => true do
      visit('/')
      page.should have_selector('#ttt')
    end
  end
end
