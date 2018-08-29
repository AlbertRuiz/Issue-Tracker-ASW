class SessionsController < ApplicationController 
  def new 
  end 
 
  def create 
    user = User.find_by(email: params[:session][:email].downcase) 
    if user && user.password_digest.nil? 
      flash.now[:danger] = 'Sign in using Google+' 
      render 'new' 
    elsif user && user.authenticate(params[:session][:password]) 
      flash.now[:success] = 'API Key: ' + user.api_key
      render 'new'
    elsif user.nil? 
      flash.now[:danger] = 'Sign in using Google+ or Sign up first' 
      render 'new' 
    else 
      flash.now[:danger] = 'Invalid email/password combination' 
      render 'new' 
    end 
  end 
 
  def google_create 
    user = User.from_omniauth(request.env["omniauth.auth"]) 
    flash.now[:success] = 'API Key: ' + user.api_key 
    render 'new'
  end 
 
end