class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, authentication_keys: [:username]

  alias authenticate valid_password?

  has_many :accounts
  validates_presence_of   :email, :username
  validates_uniqueness_of :email, :username

  def role?(role_name)
    role == role_name
  end
end
