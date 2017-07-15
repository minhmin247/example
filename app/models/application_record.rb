class ApplicationRecord < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :remember_me
  self.abstract_class = true
end
