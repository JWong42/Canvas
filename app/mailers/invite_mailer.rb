class InviteMailer < ActionMailer::Base
  include Sidekiq::Worker

  sidekiq_options retry: false
  default from: "try.canvas@gmail.com"

  def invite_email(invite_id, user_id) 
    @invite = Invite.find(invite_id)
    @user = User.find(user_id)
    mail(to: @invite.email, subject: 'Be a collaborator!')
  end
end
