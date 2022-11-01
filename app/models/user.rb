class User < ApplicationRecord
  has_many :microposts

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name   # assuming the user model has a name
      user.avatar_url = auth.info.image # assuming the user model has an image
    end
  end

  def self.search_name(id)
    @user = User.find(id)
    @user.name
  end
end
