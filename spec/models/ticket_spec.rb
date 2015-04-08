require 'rails_helper'

RSpec.describe Ticket, type: :model do
  context 'object creation' do
    it 'has none to begin with' do
      expect(Ticket.count).to eq 0
    end

    it 'has one after adding one' do
      create :ticket

      expect(Ticket.count).to eq 1
    end
  end

  context 'object validation' do
    it 'is not valid without customer_name' do
      ticket = build :ticket, customer_name: nil

      expect(ticket).to be_invalid
    end

    it 'is not valid without customer_email' do
      ticket = build :ticket, customer_email: nil

      expect(ticket).to be_invalid
    end

    it 'is not valid with incorrect email format' do
      ticket = build :ticket, customer_email: 'incorrect@format'

      expect(ticket).to be_invalid
    end

    it 'is not valid without subject' do
      ticket = build(:ticket, subject: nil)

      expect(ticket).to be_invalid
    end

    it 'is not valid without body' do
      ticket = build :ticket, body: nil

      expect(ticket).to be_invalid
    end

    it 'is not valid without department' do
      ticket = build :ticket, department: nil

      expect(ticket).to be_invalid
    end
  end

  context 'method delegation' do
    it 'responds to #username' do
      ticket = create :ticket

      expect(ticket).to respond_to(:username)
    end
  end

  describe '#assign_uref' do
    it 'generates reference code' do
      ticket = create :ticket
      expect(ticket.uref).to match /(?:[A-Z]{3}-[a-f0-9]{2}-){2}[A-Z]{3}/
    end

    it 'generates unique uref' do
      ticket_1 = create :ticket
      ticket_2 = create :ticket, uref: ticket_1.uref

      expect(ticket_2.uref).not_to eq(ticket_1.uref)
    end
  end

  describe '#reset_employee' do
    it 'sets employee to nil when ticket is cancelled' do
      ticket = create :ticket
      ticket.cancel!

      expect(ticket.employee).to be_nil
    end

    it 'sets employee to nil when ticket is completed' do
      ticket = create :ticket
      ticket.complete!

      expect(ticket.employee).to be_nil
    end
  end
end
