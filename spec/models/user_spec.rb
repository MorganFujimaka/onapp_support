require 'rails_helper'

RSpec.describe User, type: :model do
  context 'object creation' do
    it 'has none to begin with' do
      expect(User.count).to eq 0
    end

    it 'has one after adding one' do
      create :user

      expect(User.count).to eq 1
    end
  end

  describe '#employee?' do
    it 'returns true for employee' do
      user = create :user
      user.update(role: 'employee')

      expect(user.employee?).to be_truthy
    end
  end

  describe '#customer?' do
    it 'returns true for customer' do
      user = create :user

      expect(user.customer?).to be_truthy
    end
  end
end
