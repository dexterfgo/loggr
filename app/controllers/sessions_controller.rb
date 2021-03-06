class SessionsController < ApplicationController

  def index
    redirect_to root_path, notice: 'You have been logged out.' 
  end

  def new

  end

	def create
    user = User.where(isActive:true).where(isApproved:true).where(isDenied:false).find_by_email(params[:email])
    # If the user exists AND the password entered is correct.
    # if @user && @user.authenticate(params[:password])
    if (user && (user.password == Digest::MD5.hexdigest(params[:password])))
      # Save the user id inside the browser cookie. This is how we keep the user 
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      redirect_to user_home_path(user.id)
    else
    # If user's login doesn't work, send them back to the login form.
      redirect_to login_path, notice: 'Your username or password was incorrect.' 
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'You have loggd out.' 
  end
end
