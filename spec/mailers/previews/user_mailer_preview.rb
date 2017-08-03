class UserMailerPreview < ActionMailer::Preview
  attr_reader :user

  def account_activation
    @user = User.first
    user.create_activation_digest
    UserMailer.account_activation user
  end
end
