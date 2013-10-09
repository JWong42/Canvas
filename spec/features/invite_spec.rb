feature "Invite a collaborator", js: true do 
  
  given(:user_that_sent_canvas_invite) { FactoryGirl.create(:user_that_sent_canvas_invite, first_name: 'John-1', last_name: 'Doe', email: 'john-1.doe@gmail.com') }

  scenario "Send an invite" do
    sign_in user_that_sent_canvas_invite
    within 'div.canvas div.canvas-options' do
      click_link 'View Collaborators'
    end
    click_link 'Add a new collaborator -'
    fill_in 'invite-name', with: "New John"
    fill_in 'invite-email', with: "new.john@gmail.com"
    click_button 'Invite'
    expect(page).to have_selector 'div#collaborator'
    expect(page).to have_content 'Invite Pending'
  end
  
end
