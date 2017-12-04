class User < ActiveRecord::Base
  has_secure_password
  has_many :todos, foreign_key: :created_by

  validates :name, :email, :password_digest, presence: true
end
