class User < ApplicationRecord
  has_many :projects, dependent: :destroy

  attr_accessor :password_confirmation
  acts_as_authentic do |c|
    c.require_password_confirmation = true
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  validates :email,
            format: {
              with: /@/,
              message: 'Email must look like an email.'
            },
            length: { maximum: 100 },
            uniqueness: {
              case_sensitive: false,
              message: 'Email is in use by another account.',
              if: :will_save_change_to_email?
            }

  validates :login,
            format: {
              with: /\A[a-z0-9.-_@]+\z/,
              message: 'Username can only use .-_@ as symbols.'
            },
            length: {
              within: 3..100,
              message: 'Username must be between 3 and 100 characters long.'
            },
            uniqueness: {
              case_sensitive: false,
              if: :will_save_change_to_login?
            }

  validates :password,
            confirmation: {
              message: 'Password does not match.',
              if: :require_password?
            },
            length: {
              minimum: 8,
              message: 'Password is too short.',
              if: :require_password?
            }

  validates :password_confirmation,
            length: {
              minimum: 8,
              message: 'Password confirmation is too short.',
              if: :require_password?
            }

  has_permalink :login, update: false, unique: false
  validates_exclusion_of :permalink, in: ['new'], message: "Username cannot be 'new'."
  validates_uniqueness_of :permalink, message: 'Username is in use by another account.'
  validate :login_excludes_new_by_permalink, :login_is_unique_by_permalink

  before_save :check_suspicious

  def login_excludes_new_by_permalink
    errors.add(:login, "Username cannot be named 'new'.") if
      permalink == 'new'
  end

  def login_is_unique_by_permalink
    user_with_permalink = User.find_by_permalink(permalink)
    errors.add(:login, 'Username is in use by another account.') if
      user_with_permalink && user_with_permalink != self
  end

  def check_suspicious
    self.suspicious = true if email.include?('trbvn.com')
  end

  def roles
    admin? ? %i[admin user] : [:user]
  end

  def owner_of?(ownable)
    return false if ownable.class != Project

    ownable.user == self
  end

  def to_param
    permalink
  end

  def self.current
    Thread.current[:current_user]
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def current?
    self.class.current == self
  end
end
