class InviteMailer < ActionMailer::Base
  include SessionsHelper

  default from: "try.canvas@gmail.com"

  def invite_email(invite) 
    @current_user = current_user
    @invite = invite
    mail(to: @invite.email, subject: "Be a collaborator!")
  end
end
