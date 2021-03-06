# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  email           :string
#  first_name      :string
#  last_name       :string
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        user && user.is_password?(password) ? user : nil
    end

    validates :username, :password_digest, :session_token, presence: true
    validates :username, :session_token, uniqueness: true
    validates :email, uniqueness: true, allow_nil: true
    validates :password, length: { minimum: 6, allow_nil: true }

    after_initialize :ensure_token

    has_many :photos

    has_many :follows,
        foreign_key: :follower_id,
        class_name: :Follow

    has_many :followees,
        through: :follows,
        source: :followee

    has_many :followed_photos,
        through: :followees,
        source: :photos

    attr_reader :password
    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def ensure_token
        self.session_token ||= SecureRandom.urlsafe_base64
    end

    def reset_token!
        self.session_token = SecureRandom.urlsafe_base64
        self.save!
        self.session_token
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end
end
