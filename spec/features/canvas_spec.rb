require 'spec_helper'

feature "Canvas" do 

  given(:user_with_no_canvas) { FactoryGirl.create(:user) }

  scenario "User with no canvas visiting dashboard" do
    sign_in user_with_no_canvas
    current_path.should == user_path(user_with_no_canvas)
    expect(page).to have_content 'There are no existing canvases owned by you. Create one now to get started.'
    expect(page).to have_content 'No activity feeds had been created yet.'
  end

  given(:user_with_canvas) { FactoryGirl.create(:user_with_canvas) }
  background do
    sign_in user_with_canvas
  end
    
  scenario "User with canvas visiting dashboard" do 
    expect(page).to_not have_content 'There are no existing canvases owned by you. Create one now to get started.'
    expect(page).to have_content 'No activity feeds had been created yet.'
  end

  scenario "Edit name of canvas", js: true do 
    #visit user_path(user_with_canvas)
    click_link "Edit Name"
    within 'li.edit' do 
      find('input[type=text]').set('WIN') 
      click_link 'Save'
    end
    expect(page).to have_content 'WIN'
    expect(page).to have_selector 'div.feed'
    expect(page).to_not have_selector 'div.feeds p.notice'
  end

  scenario "Delete canvas", js: true do 
    click_link "Delete Canvas"
    # testing whether ajax works in removing div.canvas
    expect(page).to_not have_selector 'div.canvas'
    expect(page).to have_selector 'div.canvases p.notice'
    # revisit user page to test if canvas got removed for good
    visit user_path(user_with_canvas)
    expect(page).to_not have_selector 'div.canvas'
  end

end
