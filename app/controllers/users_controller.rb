class UsersController < ApplicationController
  def dashboard
    @user = User.find(params[:id])
  end

  def discover
    @user = User.find(params[:id])
  end

  def movies
    @user = User.find(params[:id])

    if params[:search] && params[:search] == ""
      redirect_to "/users/#{@user.id}/discover"
    elsif params[:search]
      @movies = MovieDbFacade.search_movies(params[:search])
    else
      @movies = MovieDbFacade.top_20_movies
    end
  end

  def create
    user = User.new(user_params)
    # user = User.new(name: params[:name], email: params[:email], password_digest: params[:password])

    if params[:password] != params[:password_confirmation]
      redirect_to register_path
      flash[:alert] = 'Passwords Do Not Match'
    elsif User.find_by(email: user.email)
      redirect_to register_path
      flash[:alert] = 'Email Already in Use'
    elsif user.save
      redirect_to "/users/#{user.id}"
    else
      redirect_to register_path
    end
  end

  def login_form
  end

  def login_user
    # require "pry"; binding.pry
    if User.find_by(email: params[:email]).password_digest == params[:password]
      user = User.find_by(email: params[:email])
      redirect_to "/users/#{user.id}"
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
