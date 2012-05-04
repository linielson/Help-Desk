ActionMailer::Base.smtp_settings = {
  :port                 => 587,
  :address              => 'smtp.live.com',
  :domain               => 'asseinfohelpdesk.herokuapp.com',
  :user_name            => 'sendhelpdesk@live.com',
  :password             => 'helpdesk',
  :authentication       => 'plain',
  :enable_starttls_auto => true,
  :openssl_verify_mode  => 'none'
}
#'ahelpdesk@live.com',

ActionMailer::Base.delivery_method = :smtp