class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable,:validatable, authentication_keys: [:username]

  has_many :accounts

  def role?(role_name)
    role == role_name
  end
end
