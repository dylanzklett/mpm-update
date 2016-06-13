class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  self.view_paths = File.join(Rails.root, 'app', 'views', 'mailers')

  layout 'mailer'
  default from: "no-reply@#{DOMAIN_NAME}"

  private
  def roadie_options
    super unless Rails.env.test?
  end
end
