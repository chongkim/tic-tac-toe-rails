class User < ActiveRecord::Base
  has_many :games
  attr_accessible :email, :password_hash, :password, :name, :login_token

  def password
    ""
  end
  def password= passwd
    password_hash = Digest::MD5.hexdigest(passwd)
  end

  def self.find_or_create_by_email email
    user = find_by_email(email)
    if user.nil?
      user = create!(:email => email, :login_token => Digest::MD5.hexdigest(Time.now.to_i.to_s))
    end
    return user
  end
end
