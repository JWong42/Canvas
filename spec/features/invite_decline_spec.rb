feature "Invite a collaborator", js: true do 
  
  given!(:user_that_sent_canvas_invite) { FactoryGirl.create(:user_that_sent_canvas_invite, first_name: 'John-1', last_name: 'Doe', email: 'john-1.doe@gmail.com') }
  given(:user_that_declines_invite) { FactoryGirl.create(:user, first_name: 'John-2', last_name: 'Doe', email: 'john-2.doe@gmail.com') }

  scenario "Decline an invite" do
    sign_in user_that_declines_invite
    within 'div#invites-show' do 
      click_link '1 new shared canvas invitation'
    end
    within 'div#invite div#invite-confirm' do
      click_link 'Decline'
    end 
    expect(page).to_not have_selector 'div.canvas'
    expect(page).to have_selector 'div.canvases p.notice'
  end
end
