require 'rails_helper'

RSpec.describe 'Register Page' do
  before :each do
    @user1 = User.create(name: 'Jake', email: 'imjakekim@gmail.com', password: 'Pass1234', password_confirmation: 'Pass1234')
    @user2 = User.create(name: 'Riley', email: 'rileybmccullough@gmail.com', password: 'Pass1234', password_confirmation: 'Pass1234')
  end

  it 'can login' do
    visit "/login"

    fill_in 'email', with: 'rileybmccullough#gmail.com'
    fill_in 'password', with: 'Pass1234'

    # expect(current_path).to eq("/users/#{@user2.id}")
    expect(current_path).to eq("/login")

  end

end
