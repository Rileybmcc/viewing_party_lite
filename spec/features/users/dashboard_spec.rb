require 'rails_helper'

RSpec.describe 'User Dashboard Page', :vcr do
  before :each do
    @user1 = User.create!(name: 'Jake', email: 'imjakekim@gmail.com', password: 'bjfekwpbrefipw', password_confirmation: 'bjfekwpbrefipw')
    @user2 = User.create!(name: 'Riley', email: 'rileybmccullough@gmail.com', password: 'bjfekwpbrefipw', password_confirmation: 'bjfekwpbrefipw')

    current_password = 'bjfekwpbrefipw'

    @party1 = ViewingParty.create(movie_id: 120, movie_title: 'Fellowship of the Ring', length: 200,
                                  start_time: '03:45', date: '2022-12-23')
    @party2 = ViewingParty.create(movie_id: 457_840, movie_title: 'Psych the Movie', length: 150, start_time: '18:45',
                                  date: '2022-11-23')

    @user_party1 = ViewingPartyUser.create(viewing_party_id: @party1.id, user_id: @user1.id, status: 0)
    @user_party2 = ViewingPartyUser.create(viewing_party_id: @party2.id, user_id: @user1.id, status: 1)
    @user_party3 = ViewingPartyUser.create(viewing_party_id: @party2.id, user_id: @user2.id, status: 0)

    visit "/login"
    fill_in :email, with: @user1.email
    fill_in :password, with: current_password
    # save_and_open_page
    click_on 'Login'
  end

  it 'has propper page attributes from only user 1' do
    # visit "/login"
    # fill_in 'email', with: 'imjakekim@gmail.com'
    # fill_in 'password', with: 'bjfekwpbrefipw'
    # click_on 'Login'
    # require "pry"; binding.pry
    # session[:user_id] = @user1.id
    visit "/dashboard"
    expect(page).to have_content('Viewing Party Lite')
    expect(page).to have_content("Jake's Dashboard")
    expect(page).to have_button('Return to the Homepage')
    expect(page).to have_content('Viewing Parties')
  end

  it "shows user's viewing_parties" do
    visit "/dashboard"
    expect(page).to have_content("#{@user1.name}'s Dashboard")
    expect(page).to have_content(@party1.movie_title)
    expect(page).to have_content("Date: #{@party1.date.strftime('%B %-d, %Y')}")
    expect(page).to have_content("Starting Time: #{@party1.start_time.strftime('%I:%M %p')}")
    expect(page).to have_content("Status: #{@user_party1.status}")
  end

  it 'has a discover movie button' do
    visit "/dashboard"
    # save_and_open_page
    expect(page).to have_button('Discover Movies')
    click_on 'Discover Movies'
    expect(current_path).to eq("/discover")
  end
end
