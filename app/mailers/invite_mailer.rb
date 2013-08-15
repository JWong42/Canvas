class InviteMailer < ActionMailer::Base

  default from: "try.canvas@gmail.com"

  def invite_email(invite, current_user) 
    @invite = invite
    @current_user = current_user
    mail(to: @invite.email, subject: 'Be a collaborator')
  end
end
