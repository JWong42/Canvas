require 'spec_helper'

feature "Signing up" do 
  background do 
    visit signup_path 
  end

  given(:user) { FactoryGirl.build(:user) }

  scenario "Signing up with valid information" do 
    within("form#new_user") do
    fill_in 'user_first_name', with: user.first_name
    fill_in 'user_last_name', with: user.last_name
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password_confirmation
    end
    click_button "Create my account"
    expect(page).to have_selector 'div.alert.alert-success', text: 'Welcome!'
  end

  scenario "Signing up with invalid information" do 
    click_button "Create my account"
    expect(page).to have_error_message 'The form contains 6 errors.'
  end
end
