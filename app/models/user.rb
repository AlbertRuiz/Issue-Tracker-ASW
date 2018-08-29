class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
	has_many :issues
	has_many :comments
	has_many :votes
	has_many :watches 

    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, 
                      uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true

	#def name_email
	#	self.name + " (" + self.email + ")"
	#end

  before_create do |u|
    u.api_key = u.generate_api_key
  end

	def self.digest(string)
    	cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
 	end

#	def self.new_token
 #   	SecureRandom.urlsafe_base64
  #	end

  	#def remember
  #  	self.remember_token = User.new_token
  #  	update_attribute(:remember_digest, User.digest(remember_token))
 	#end

 	#def authenticated?(remember_token)
 #		return false if remember_digest.nil?
 #   	BCrypt::Password.new(remember_digest).is_password?(remember_token)
 #   end#


  	#def forget
   # 	update_attribute(:remember_digest, nil)
  #	end

    def self.from_omniauth(auth)
      where(email: auth.info.email).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.picture = auth.info.image
      user.password = "this is the password when authentication"
      user.save
    end
  end

  def generate_api_key
    loop do
      key = SecureRandom.urlsafe_base64(nil,false)
      break key unless User.exists?(api_key: key)
    end
  end

end
