ActionMailer::Base.smtp_settings = {
  :port                 => 587,
  :address              => 'smtp.gmail.com',
  :domain               => 'projecthelpdesk.herokuapp.com',
  :user_name            => 'projecthdesk@gmail.com',
  :password             => 'helpdeskteste',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}

ActionMailer::Base.delivery_method = :smtp