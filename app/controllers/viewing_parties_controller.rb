class ViewingPartiesController < ApplicationController
  def new
    # @user = User.find(params[:id])
    @movie = MovieDbFacade.find_by_movie_id(params[:movie_id])
    @other_users = User.all.where.not(id: session[:user_id])
  end

  def create
    # user = User.find(params[:id])
    movie = MovieDbFacade.find_by_movie_id(params[:movie_id])
    new_view_party = ViewingParty.new(movie_id: movie.id, movie_title: movie.title, start_time: params[:start_time],
                                      date: params[:date], length: params[:length])

    if params[:length].to_i >= movie.runtime && new_view_party.valid?  # these - active model validations
      new_view_party.save
      ViewingPartyUser.create(viewing_party_id: new_view_party.id, user_id: session[:user_id], status: 0)

      unless params[:user].nil?
        added_users = params[:user].select { |user| user != '0' }
        added_users.each { |usr| ViewingPartyUser.create(viewing_party_id: new_view_party.id, user_id: usr, status: 1) }
      end

      redirect_to "/dashboard"
    else
      flash[:alert] = 'Fill all the Damn fields!'
      redirect_to "/movies/#{movie.id}/viewing_party/new"
    end
  end
end
