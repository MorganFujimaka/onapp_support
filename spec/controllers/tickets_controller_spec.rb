require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  let(:user)       { create :user       }
  let(:employee)   { create :employee   }
  let(:ticket_1)   { create :ticket     }
  let(:ticket_2)   { create :ticket     }
  let(:department) { create :department }

  describe 'GET index' do
    it 'exposes all tickets' do
      get :index
      
      expect(controller.tickets).to eq([ticket_1, ticket_2])
    end
  end

  describe 'GET show' do
    it 'exposes the requested ticket' do
      get :show, id: ticket_1

      expect(controller.ticket).to eq(ticket_1)
      expect(response).to render_template('show')
    end

    it 'raises exception if ticket is not found' do
      get :show, id: 0
      
      expect { controller.ticket }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'GET new' do
    context 'as employee' do
      before { sign_in 'employee' }
      it 'redirects to root path' do
        get :new

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'as customer' do
      before { sign_in user }
      
      include_examples 'customer_new_ticket'
    end

    context 'as guest' do
      before { sign_in false }
      
      include_examples 'customer_new_ticket' 
    end
  end

  describe 'POST create' do
    context 'as employee' do
      before { sign_in 'employee' }
      it 'redirects to root path' do
        post :create, ticket: attributes_for(:ticket), department: department

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
      end
    end

    context 'as customer' do
      before { sign_in user }

      include_examples 'customer_create_ticket'
    end

    context 'as guest' do
      before { sign_in false }

      include_examples 'customer_create_ticket'
    end
  end

  describe 'GET edit' do
    context 'as employee' do
      before { sign_in 'employee' }
      
      include_examples 'guest_edit_ticket'
    end

    context 'as customer' do
      before { sign_in user }

      context 'owner' do
        it 'exposes requested ticket' do
          ticket = create :ticket, customer_email: user.email
          get :edit, id: ticket

          expect(controller.ticket).to eq(ticket)
          expect(response).to render_template('edit')
        end
      end

      context 'not owner' do
        it 'redirects to root path' do
          get :edit, id: ticket_1

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end
    end

    context 'as guest' do
      before { sign_in false }

      include_examples 'guest_edit_ticket'
    end
  end

  describe 'PATCH update' do
    context 'as employee' do
      before { sign_in 'employee' }
      
      include_examples 'guest_update_ticket'
    end

    context 'as customer' do
      context 'owner' do
        before { sign_in user }
        it 'redirects to updated ticket' do
          ticket = create :ticket, customer_email: user.email
          patch :update, id: ticket, ticket: ticket.attributes.merge(body: 'Updated text')
          ticket.reload

          expect(ticket.body).to eq('Updated text')
          expect(response).to redirect_to(ticket)
        end
      end

      context 'not owner' do
        it 'redirects to root path' do
          patch :update, id: ticket_1

          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You are not authorized to access this page.')
        end
      end
    end

    context 'as guest' do
      before { sign_in false }

      include_examples 'guest_update_ticket'
    end
  end

  describe 'PATCH change_status' do
    context 'as employee' do
      before do
        sign_in 'employee'
      end

      it 'changes status and creates Rreply' do
        expect { 
          patch :change_status, id: ticket_1, ticket: ticket_1.attributes.merge(aasm_state: 'waiting_for_customer')
          }.to change(Reply, :count).by(1)
        expect(Reply.last.body).to eq('Status was changed to Waiting for customer')
        
        ticket_1.reload
        expect(ticket_1.aasm_state).to eq('waiting_for_customer')
        expect(response).to redirect_to(ticket_1)
        expect(flash[:success]).to eq('Status was changed successfully')
      end

      it 'renders show template' do
        allow_any_instance_of(Ticket).to receive(:save).and_return(false)
        expect { 
          patch :change_status, id: ticket_1, ticket: ticket_1.attributes
        }.to change(Reply, :count).by(0)
        expect(response).to render_template('show')
        expect(flash[:alert]).to eq('Unable to change status. Please try again')
      end
    end

    context 'as customer' do
      before { sign_in user }

      include_examples 'customer_change_status'
    end

    context 'as customer' do
      before { sign_in false }

      include_examples 'customer_change_status'
    end
  end

  describe 'PATCH change_employee' do
    context 'as employee' do
      before do
        sign_in 'employee'
      end

      let(:user)     { employee.create_user(attributes_for(:user)) }

      it 'assign to employee and creates Reply' do
        allow(employee).to receive(:username).and_return(user.username)
        expect { 
          patch :change_assignee, id: ticket_1, ticket: ticket_1.attributes.merge(employee_id: employee)
        }.to change(Reply, :count).by(1)
        expect(Reply.last.body).to eq("Ticket was assigned to #{employee.username}")

        ticket_1.reload
        expect(ticket_1.employee).to eq(employee)
        expect(response).to redirect_to(ticket_1)
        expect(flash[:success]).to eq('Assignee was changed successfully')
      end

      it 'renders show template' do
        allow_any_instance_of(Ticket).to receive(:update).and_return(false)
        expect { 
          patch :change_assignee, id: ticket_1, ticket: ticket_1.attributes.merge(employee_id: employee)
        }.to change(Reply, :count).by(0)
        expect(response).to render_template('show')
        expect(flash[:alert]).to eq('Unable to change assignee. Please try again')
      end
    end

    context 'as customer' do
      before { sign_in user }

      include_examples 'customer_assignee_status'
    end

    context 'as customer' do
      before { sign_in false }

      include_examples 'customer_assignee_status'
    end
  end
end
