# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Identity.setup do |config|
  config.user_class_name = "User"
  config.devise_modules = [
    :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  ]
  config.layout = "non_logged"

  # ==> Mailer Configuration
  config.mailer_sender = Proc.new { "no-reply@#{DOMAIN_NAME}" }

  # ==> Configuration for any authentication mechanism
  config.secret_key = '725d86022adcdff8a2862cca412329f40c2f8b9ba1fb18aa276d48ebd095fed06886ba525d585cd0863e3d1ddc38e5e8948ca5f41c1a065d1914a14b116bb083'
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 10

  # ==> Configuration for :rememberable
  config.expire_all_remember_me_on_sign_out = true

  # ==> Configuration for :validatable
  config.password_length = 8..128
  config.email_regexp = /\A[^@]+@[^@]+\z/

  # ==> Configuration for :recoverable
  config.reset_password_within = 6.hours
end
