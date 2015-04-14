require "rails_helper"

RSpec.describe CustomerMailer, type: :mailer do
  let(:ticket)   { create :ticket }
  let(:reply)    { create :reply  }

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  describe '#new_ticket_email' do
    before { CustomerMailer.new_ticket_email(ticket).deliver_now }

    it 'sends an email' do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'renders the receiver email' do
      expect(ActionMailer::Base.deliveries.first.to).to eq([ticket.customer_email])
    end

    it 'sets the subject to the correct subject' do
      expect(ActionMailer::Base.deliveries.first.subject).to eq("#{ticket.uref} - Your ticket was added successfully")
    end

    it 'renders the sender email' do  
      expect(ActionMailer::Base.deliveries.first.from).to eq(['support@onappapp.com'])
    end
  end

  describe '#ticket_updates' do
    before do
      CustomerMailer.ticket_updates(reply).deliver_now
    end

    it 'sends an email' do
      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it 'renders the receiver email' do
      expect(ActionMailer::Base.deliveries.first.to).to eq([reply.customer_email])
    end

    it 'sets the subject to the correct subject' do
      expect(ActionMailer::Base.deliveries.first.subject).to eq("#{reply.ticket.uref} - Your ticket was updated")
    end

    it 'renders the sender email' do  
      expect(ActionMailer::Base.deliveries.first.from).to eq(['support@onappapp.com'])
    end
  end
end
