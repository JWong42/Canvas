require 'spec_helper'

# To Do 

# Dashboard functionality
# Canvas functionality - add item, change label and delete item
# Invite collaborator, accept invite, decline invite

feature "Authentication" do 
  background do 
    visit signin_path
  end

  given(:user) { FactoryGirl.create(:user) }
  
  scenario "Signing in with valid information" do 
    within("form.new_session") do 
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
    end
    click_button 'Sign in'
    expect(page).to have_content 'Dashboard'
    expect(page).to have_navbar_for_signed_in_user
    expect(page).to have_link 'Sign out', href: signout_path
  end

  scenario "Signing in with invalid information" do
    click_button 'Sign in'
    expect(page).to have_error_message 'Invalid email or password.'
    expect(page).to have_navbar_for_signed_out_user
  end
end
