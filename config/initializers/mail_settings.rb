ActionMailer::Base.smtp_settings = {
  :address              => 'smtp.live.com',
  :port                 => 587,
  :domain               => 'asseinfo.com',
  :user_name            => 'sendhelpdesk@live.com',
  :password             => 'helpdesk',
  :authentication       => 'plain',
  :enable_starttls_auto => true,
  :openssl_verify_mode  => 'none'
}
#'ahelpdesk@live.com',
