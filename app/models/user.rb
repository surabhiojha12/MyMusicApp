class User < ActiveRecord::Base
    has_many :songs,dependent: :destroy
    has_many :playlists, dependent: :destroy
    has_secure_password
    validates_confirmation_of :password
    validates :username, presence: true, length: {minimum: 5}
    validates :email, presence: true, :uniqueness => { :case_sensitive => false }, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :phone_no, presence: true, length: {minimum: 10, maximum: 10}, :uniqueness => { :case_sensitive => false }
    validates :type_of_user, :inclusion => {:in => [true, false]}
    
end
