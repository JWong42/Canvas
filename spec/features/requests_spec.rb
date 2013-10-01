require 'spec_helper'

feature "Visiting site pages" do 
  scenario "Visit home page" do 
    visit root_path
    expect(page).to have_content "Discover Why Canvas is Awesome"
    expect(page).to have_content "Testimonials"
  end

  scenario "Visit signin page" do 
    visit signin_path
    expect(page).to have_content "Sign In"
  end

  scenario "Visit signup page" do 
    visit signup_path
    expect(page).to have_content "Sign Up"
  end

  after do
    expect(page).to have_navbar_for_signed_out_user  
    expect(page).to have_footer  
  end
end 
