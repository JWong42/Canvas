require 'spec_helper'

feature "Authorization" do 

  given(:correct_user) { FactoryGirl.create(:user_with_canvas) } 
  given(:incorrect_user) { FactoryGirl.create(:user_with_canvas) } 
  background { sign_in correct_user }

  scenario "Viewing incorrect user's edit profile page" do
    visit edit_user_path(incorrect_user)
    current_path.should == root_path
    expect(page).to_not have_content 'Your Canvases'
  end

  scenario "Viewing incorrect user's canvas page" do
    visit user_canvas_path(correct_user, incorrect_user.canvases.first)
    current_path.should == root_path
  end
  
end


