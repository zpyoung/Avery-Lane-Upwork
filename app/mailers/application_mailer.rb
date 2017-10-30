class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  default from: "#{Rails.configuration.app_name} <info@averylane.com>"
  layout 'mailer'
end
