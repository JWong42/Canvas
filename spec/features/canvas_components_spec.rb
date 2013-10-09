require 'spec_helper'

feature "Canvas Components", js: true do 

  given(:user_with_canvas) { FactoryGirl.create(:user_with_canvas) } 
  background do 
    sign_in user_with_canvas
    visit user_canvas_path(user_with_canvas, user_with_canvas.canvases.first)
  end

  scenario "Add an item" do 
    find('td#problems').click
    within 'div.item-insert' do 
      find('input[type=text]').set('Business needs more customer leads')
      click_link 'Save'
    end
    expect(page).to have_content 'Business needs more customer leads'
  end

  scenario "Change label of an item" do 
    within 'td#problems' do 
      page.execute_script('$("div.item-options").trigger("mouseenter")')
      find('a.switch-color').click
      find('a.switch-color').click
    end
      find('div.item li')['style'].should == "color: rgb(97, 220, 63);"
  end

  scenario "Delete an item" do 
    within 'td#problems' do 
      page.execute_script('$("div.item-options").trigger("mouseenter")')
      find('a.remove-item').click
    end 
    expect(page).to_not have_selector 'div.item-container'
  end

end
