class UsersController < ApplicationController
  def dashboard
    # require "pry"; binding.pry
    # @user = User.find(params[:id])
    # @user = User.find(session[:user_id])
  end

  def discover
    # require "pry"; binding.pry
    # @user = User.find(params[:id])
  end

  def movies
    # @user = User.find(session[:id])

    if params[:search] && params[:search] == ""
      redirect_to "/discover"
    elsif params[:search]
      @movies = MovieDbFacade.search_movies(params[:search])
    else
      @movies = MovieDbFacade.top_20_movies
    end
  end

  def create
    user = User.new(user_params)
# require "pry"; binding.pry
    if params[:password] != params[:password_confirmation]
      redirect_to register_path
      flash[:alert] = 'Passwords Do Not Match'
    elsif User.find_by(email: user.email)
      redirect_to register_path
      flash[:alert] = 'Email Already in Use'
    elsif user.save
      session[:user_id] = user.id
      # log_in user
      redirect_to "/dashboard"
    else
      redirect_to register_path
    end
  end

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    # require "pry"; binding.pry
    if user != nil && user.authenticate(params[:password])
      # session[:user_id] = user.id
      redirect_to "/dashboard"
    else
      flash[:alert] = 'Email or Password did not Match'
      redirect_to '/login'
    end
  end

  def logout
    session.clear
    redirect_to root_path
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
