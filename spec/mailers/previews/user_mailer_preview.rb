class UserMailerPreview < ActionMailer::Preview
  attr_reader :user

  def account_activation
    @user = User.first
    user.create_activation_digest
    UserMailer.account_activation user
  end

  def password_reset
    @user = User.first
    user.create_reset_digest
    UserMailer.password_reset user
  end
end
