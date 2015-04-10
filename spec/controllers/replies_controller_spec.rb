require 'rails_helper'

RSpec.describe RepliesController, type: :controller do
  let(:ticket)           { create         :ticket }
  let(:user)             { create         :user   }
  let(:valid_attributes) { attributes_for :reply  }

  describe 'POST create' do
    let(:invalid_params) { { reply: { ticket: ticket, user: user } } }

    context 'as employee' do
      before { sign_in 'employee' }

      it 'redirects to ticket if reply is valid' do
        expect { post :create, reply: attributes_for(:reply), ticket_id: ticket }.to change(Reply, :count).by(1)
        expect(response).to redirect_to(Reply.last.ticket)
      end

      it 'render ticket/show if reply is invalid' do
        expect { post :create, reply: { body: nil }, ticket_id: ticket }.to change(Reply, :count).by(0)
        expect(response).to render_template('tickets/show')
      end
    end

    context 'as customer' do
      before { sign_in user }

      include_examples 'customer_create_reply'
    end

    context 'as guest' do
      before { sign_in false }
      
      include_examples 'customer_create_reply'
    end
  end
end
