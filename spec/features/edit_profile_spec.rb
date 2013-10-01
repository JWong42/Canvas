require 'spec_helper'

feature "Editing user profile" do 
  given(:user) { FactoryGirl.create(:user) }

  background do 
    sign_in(user)
    visit edit_user_path(user) 
  end

  scenario "Editing profile with valid information" do 
    within("form.edit_user") do
    fill_in 'user_first_name', with: user.first_name
    fill_in 'user_last_name', with: user.last_name
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password_confirmation
    end
    click_button "Save changes"
    expect(page).to have_selector 'div.alert.alert-success', text: 'Profile updated'
  end

  scenario "Editing profile with invalid information" do 
    click_button "Save changes"
    expect(page).to have_error_message 'The form contains 3 errors.'
  end
end
