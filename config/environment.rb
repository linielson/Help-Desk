# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Helpdesk::Application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<label/
    %|<div class="fieldWithErrors">#{html_tag} <span class="error" style='font-style:italic;'>#{[instance.error_message].join(', ')}</span></div>|.html_safe
  else
    html_tag
  end
end