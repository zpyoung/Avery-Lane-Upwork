class UsersController < ApplicationController
  layout "list_items"
  responders :ajax_modal, :collection
  respond_to :js, only: [:index, :new, :create, :edit, :update]
  respond_to :html, only: [:index, :destroy, :resend_invite]

  load_and_authorize_resource

  def index
    @search = @users.ransack(params[:q])
    @search.sorts = ["first_name asc", "last_name asc"] if @search.sorts.empty?
    @users = @search.result.page(params[:page])
    respond_with(@pusers)
  end

  def new
    @user.role = User::Role::ADMIN
    respond_with(@user)
  end

  def create
    @user = User.invite!(user_params, current_user)
    respond_with(@user)
  end

  def edit
    respond_with(@user)
  end

  def update
    @user.update(user_params)
    respond_with(@user)
  end

  def destroy
    @user.soft_delete
    if @user == current_user
      sign_out(@user)
    end
    respond_with(@user)
  end
  
  def resend_invite
    if @user.invited_to_sign_up?
      @user.invite!
    end
    respond_with(@user)
  end

  protected

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :role, :support, :phone, :time_zone)
  end
end
