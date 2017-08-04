class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("activation.text7")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("reset.text3")
  end
end
