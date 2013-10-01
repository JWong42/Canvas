require 'spec_helper'

feature "Authorization", type: :request do 

  given(:correct_user) { FactoryGirl.create(:user) } 
  given(:incorrect_user) { FactoryGirl.create(:user) } 
  background { sign_in correct_user }

  scenario "Viewing incorrect user's edit profile page" do
    visit edit_user_path(incorrect_user)
    current_path.should == root_path
    expect(page).to_not have_content 'Your Canvases'
  end
end


