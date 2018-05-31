class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:vkontakte, :twitter]

  has_many :questions
  has_many :answers
  has_many :comments
  has_many :authorizations

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.email
    user = User.where(email: email).first

    unless user
      email ||= "#{Devise.friendly_token[0, 10]}@email.temp"
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)

      user.skip_confirmation!
      user.save
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def author_of?(resource)
    resource.user_id == self.id
  end

  def email_temp?
    email =~ /@email.temp/
  end
end
