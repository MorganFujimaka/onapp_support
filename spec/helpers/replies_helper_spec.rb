require 'rails_helper'

RSpec.describe RepliesHelper, type: :helper do
  describe '#employees_names' do
    it 'expose employees names for select' do
      employee_1 = create :employee
      employee_2 = create :employee
      user_1     = employee_1.create_user(attributes_for(:user))
      user_2     = employee_2.create_user(attributes_for(:user))

      expect(helper.employees_names).to eq([[employee_1.username, employee_1.id], [employee_2.username, employee_2.id]])
    end
  end
end
