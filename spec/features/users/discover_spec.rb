require 'rails_helper'

RSpec.describe 'User Discover Page' do
  before :each do
    visit "/login"
    fill_in 'email', with: 'imjakekim@gmail.com'
    fill_in 'password', with: 'grjwbhiapqbvf'
    click_on 'Login'

    # @user1 = User.create(name: 'Jake', email: 'imjakekim@gmail.com', password_digest: 'grjwbhiapqbvf')
    @user2 = User.create(name: 'Riley', email: 'rileybmccullough@gmail.com', password_digest: 'grjwbhiapqbvf')

    @party1 = ViewingParty.create(movie_title: 'Fellowship of the Ring', length: 200, start_time: '2022-11-18 03:45')
    @party2 = ViewingParty.create(movie_title: 'Psych the Movie', length: 150, start_time: '2022-12-30 18:45')

    @user_party1 = ViewingPartyUser.create(viewing_party_id: @party1.id, user_id: User.find_by(name: 'Jake'), status: 0)
    @user_party2 = ViewingPartyUser.create(viewing_party_id: @party2.id, user_id: User.find_by(name: 'Jake'), status: 1)

  end

  it 'can search movies', :vcr do
    # session[:user_id] = @user1.id
    visit "/discover"

    fill_in 'search', with: 'Phoenix'
    click_on 'Find Movies'
    expect(current_path).to eq("/movies")
  end

  it 'can search top rated movies', :vcr do
    visit "/discover"
    click_on 'Discover Top Rated Movies'
    expect(current_path).to eq("/movies")
  end

  it 'can return discover details' do
    visit "/discover"

    expect(page).to have_content('Viewing Party Lite')
    expect(page).to have_content('Discover Movies')

    expect(page).to have_button('Discover Top Rated Movies')

    expect(page).to have_field('Search By Movie Title:')
    expect(page).to have_button('Find Movies')
  end

  it 'can search an empty field and be returned', :vcr do
    visit "/discover"

    click_on 'Find Movies'
    expect(current_path).to eq("/discover")
  end
end
