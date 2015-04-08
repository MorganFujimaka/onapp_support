require 'rails_helper'

RSpec.describe Employee, type: :model do
  context 'method delegation' do
    it 'responds to #username' do
      employee = create :employee

      expect(employee).to respond_to(:username)
    end
  end
end
