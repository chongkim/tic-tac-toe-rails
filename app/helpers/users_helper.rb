module UsersHelper
  def hash_password password
    Digest::MD5.hexdigest(password)
  end
end
