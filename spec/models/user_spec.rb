require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'relationships' do
    it { should have_many :viewing_party_users }
    it { should have_many(:viewing_parties).through(:viewing_party_users) }
  end

  describe 'attributes' do
    it { should validate_uniqueness_of(:email)}
    it { should validate_presence_of(:password_digest)}
    it { should have_secure_password}

    it 'can obscure password' do
      
      user = User.create(name: 'Blue', email: 'bluesinstall@gmail.com', password: '12345', password_confirmation: '12345')

      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('password1234')
    end

  end



end
