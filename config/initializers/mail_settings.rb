ActionMailer::Base.smtp_settings = {
  :port                 => 587,
  :address              => 'smtp.asseinfo.com.br',
  :domain               => 'asseinfohelpdesk.herokuapp.com',
  :user_name            => 'testdesk@asseinfo.com.br',
  :password             => 'senhateste123',
  :authentication       => 'plain',
  :enable_starttls_auto => true,
  :openssl_verify_mode  => 'none'
}

ActionMailer::Base.delivery_method = :smtp