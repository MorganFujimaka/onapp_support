require 'rails_helper'

RSpec.describe Reply, type: :model do
  let(:user) { create :user }
  let(:ticket) { create :ticket }

  context 'object creation' do
    it 'has none to begin with' do
      expect(Reply.count).to eq 0
    end

    it 'has one after adding one' do
      create :reply

      expect(Reply.count).to eq 1
    end
  end

  context 'object validation' do
    it 'is not valid without body' do
      reply = build :reply, body: nil

      expect(reply).to be_invalid
    end

    it 'is not valid without employee' do
      reply = build :reply, employee: nil

      expect(reply).to be_invalid
    end

    it 'is not valid without ticket' do
      reply = build :reply, ticket: nil

      expect(reply).to be_invalid
    end
  end

  context 'method delegation' do
    it 'responds to #username' do
      reply = create :reply

      expect(reply).to respond_to(:username)
    end

    it 'responds to #customer_email' do
      reply = create :reply

      expect(reply).to respond_to(:customer_email)
    end
  end

  context 'callback' do
    it 'triggers #send_email after save' do
      reply = build :reply

      expect(reply).to receive(:send_email)
      reply.save
    end
  end
end
