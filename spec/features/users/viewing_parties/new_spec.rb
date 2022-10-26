require 'rails_helper'

RSpec.describe 'User Viewing Party New Page', :vcr do
  before :each do
    visit "/register"
    fill_in :name, with: 'Jake'
    fill_in :email, with: 'imjakekim@gmail.com'
    fill_in :password, with: '1234'
    fill_in :password_confirmation, with: '1234'
    click_on 'Create New User'

    # @user1 = User.create(name: 'Jake', email: 'imjakekim@gmail.com', password_digest: 'gburiewvbijvero')
    @user2 = User.create(name: 'Riley', email: 'rileybmccullough@gmail.com', password_digest: 'gburiewvbijvero')
    @user3 = User.create(name: '123', email: '123@gmail.com', password_digest: 'gburiewvbijvero')
    @user4 = User.create(name: 'abc', email: 'abc@gmail.com', password_digest: 'gburiewvbijvero')
  end

  it 'has required fixed content on new page' do
    visit "/movies/238/viewing_party/new"

    expect(page).to have_button('Discover Page')
    expect(page).to have_button('Create Party')
    expect(page).to have_content('Movie Title')
    expect(page).to have_content('Duration of Party')
    expect(page).to have_content('Day')
    expect(page).to have_content('Start Time')
    expect(page).to have_content('Invite Other Users')
  end

  it 'has required varying content on new page' do
    visit "/movies/238/viewing_party/new"

    expect(page).to have_content('The Godfather')
    expect(page).to have_content('Riley (rileybmccullough@gmail.com)')
  end

  it 'can use the Discover Page button to go back' do
    visit "/movies/238/viewing_party/new"
    click_button 'Discover Page'

    expect(current_path).to eq("/discover")
  end

  it 'can submit new viewing party form' do
    visit "/movies/238/viewing_party/new"

    fill_in 'Duration of Party', with: '240'
    fill_in 'Day', with: "#{Date.tomorrow}"
    fill_in 'Start Time', with: '20:00'
    check "user_#{@user2.id}"
    check "user_#{@user3.id}"

    click_button 'Create Party'
    expect(current_path).to eq("/dashboard")
  end

  it 'can create new viewing party and viewing party users' do
    visit "/movies/238/viewing_party/new"

    fill_in 'Duration of Party', with: '240'
    fill_in 'Day', with: "#{Date.tomorrow}"
    fill_in 'Start Time', with: '20:00'
    check "user_#{@user2.id}"
    check "user_#{@user3.id}"

    click_button 'Create Party'

    newest_view_party = ViewingParty.find_by(movie_id: 238)

    expect(current_path).to eq("/dashboard")
    expect(page).to have_content('hosting')
    expect(newest_view_party)
    expect(ViewingPartyUser.find_by(viewing_party_id: newest_view_party.id, user_id: User.find_by(name: 'Jake')).status).to eq('hosting')
    expect(ViewingPartyUser.find_by(viewing_party_id: newest_view_party.id, user_id: @user2.id).status).to eq('invited')
    expect(ViewingPartyUser.find_by(viewing_party_id: newest_view_party.id, user_id: @user3.id).status).to eq('invited')
  end

  it 'cannot create new viewing party if length is shorter than runtime' do
    visit "/movies/238/viewing_party/new"

    fill_in 'Duration of Party', with: '10'
    fill_in 'Day', with: "#{Date.tomorrow}"
    fill_in 'Start Time', with: '20:00'
    check "user_#{@user2.id}"
    check "user_#{@user3.id}"

    click_button 'Create Party'

    expect(current_path).to eq("/movies/238/viewing_party/new")
    newest_view_party = ViewingParty.find_by(length: 10)
    expect(newest_view_party).to eq(nil)
  end

  it 'cannot create new viewing party if start time is nil' do
    visit "/movies/238/viewing_party/new"

    fill_in 'Duration of Party', with: '360'
    fill_in 'Day', with: 'Date.tomorrow'
    check "user_#{@user2.id}"
    check "user_#{@user3.id}"

    click_button 'Create Party'

    newest_view_party = ViewingParty.find_by(length: 360)
    expect(newest_view_party).to eq(nil)
  end

  it 'cannot create new viewing party if date is nil' do
    visit "/movies/238/viewing_party/new"

    fill_in 'Duration of Party', with: '360'
    fill_in 'Start Time', with: '20:00'
    check "user_#{@user2.id}"
    check "user_#{@user3.id}"

    click_button 'Create Party'

    newest_view_party = ViewingParty.find_by(length: 360)
    expect(newest_view_party).to eq(nil)
  end
end
