class ApplicationController < ActionController::Base
 protect_from_forgery
  skip_before_action :verify_authenticity_token, if: :json_request?
 
  protected
 
  def json_request?
    request.format.json?
  end
  include SessionsHelper
  
  def authenticate
  	api_key = request.headers['access-token']
  	@user = User.where(api_key: api_key).first if api_key
  end
 
end

