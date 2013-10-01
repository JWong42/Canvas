def sign_in(user)
  visit signin_path
  within("form.new_session") do
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
  end
  click_button 'Sign in'
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_basic_navbar_links do
  match do |page|
    expect(page).to have_link 'Canvas', href: root_path
    expect(page).to have_link 'Home', href: root_path
  end
end

RSpec::Matchers.define :have_navbar_for_signed_out_user do
  match do |page|
    expect(page).to_not have_link 'Notification'
    expect(page).to_not have_link 'Account'
    expect(page).to have_link 'Sign in', href: signin_path
    expect(page).to have_basic_navbar_links
  end
end

RSpec::Matchers.define :have_navbar_for_signed_in_user do
  match do |page|
    expect(page).to have_link 'Notification'
    expect(page).to have_link 'Account'
    expect(page).to have_basic_navbar_links
  end
end

RSpec::Matchers.define :have_footer do 
  match do |page|
    expect(page).to have_selector 'footer'
    expect(page).to have_content 'Information'
    expect(page).to have_content 'Keep in touch'
    expect(page).to have_content 'Subscribe and get updates'
    expect(page).to have_selector 'div.copyright'
  end
end
