class UsersController < ApplicationController
  include UsersHelper
  # GET /users/new
  # GET /users/new.json
  def new
    @user = params[:login_token] ? User.find_by_login_token(params[:login_token]) : User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def edit
    @user = params[:login_token] ? User.find_by_login_token(params[:login_token]) : User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.login_token = nil
    @user.password_hash = hash_password(@user.password)
    if (@user.update_attributes(params[:user]))
      session[:user_id] = @user.id
      redirect_to(session[:original_path] || root_path)
    else
      render action: "edit"
    end
  end

  # POST /users
  # POST /users.json
  def create
    params[:user][:password_hash] = hash_password(params[:user][:password])
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def sign_out
    session[:user_id] = nil
    redirect_to root_path
  end

  def sign_in
    if params[:email]
      @user = User.find_by_email(params[:email])
      if @user
        if @user.password_hash == hash_password(params[:password])
          session[:user_id] = @user.id
          redirect_to root_path
        else
          flash[:error] = "Password does not match"
          redirect_to sign_in_path
        end
      else
        flash[:error] = "No user by that email"
        redirect_to sign_in_path
      end
    end
  end
end
