class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :html, :json, :xml

  before_filter :authenticate_usuario!
end
