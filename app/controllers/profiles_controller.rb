class ProfilesController < ApplicationController
  responders :ajax_modal 
  respond_to :js

  before_action :load_user

  def edit
    respond_with(@user)
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    if @user.update_with_password(update_user_params)
      sign_in(@user, bypass_sign_in: true)
    end
    respond_with(@user, location: root_path)
    @user.password = @user.password_confirmation =  nil
  end

  protected

  def update_user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :first_name, :last_name, :time_zone)
  end

  def load_user
    @user = current_user
  end
end
