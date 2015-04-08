require 'rails_helper'

RSpec.describe RepliesController, type: :controller do
  let(:ticket)           { create         :ticket }
  let(:user)             { create         :user   }
  let(:valid_attributes) { attributes_for :reply  }

  describe 'POST create' do
    let(:invalid_params) { { reply: { ticket: ticket, user: user } } }

    context 'as employee' do
      before { sign_in 'employee' }

      it 'redirects to ticket' do
        expect { post :create, reply: attributes_for(:reply), ticket_id: ticket }.to change(Reply, :count).by(1)
        expect(response).to redirect_to(Reply.last.ticket)
      end
    end

    context 'as customer' do
      before { sign_in user }

      it 'redirects to ticket' do
        expect { post :create, reply: attributes_for(:reply), ticket_id: ticket }.to change(Reply, :count).by(0)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end
  end
end
