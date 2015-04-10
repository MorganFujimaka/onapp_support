RSpec.shared_examples 'customer_new_ticket' do
  it 'exposes new ticket' do
    get :new

    expect(response).to render_template('new')
    expect(controller.ticket).to be_a_new(Ticket)
  end
end

RSpec.shared_examples 'customer_create_ticket' do
  it 'creates a new Ticket' do
    expect {
      post :create, ticket: attributes_for(:ticket, department_id: department)
    }.to change(Ticket, :count).by(1)
  end

  it 'exposes newly created ticket' do
    post :create, ticket: attributes_for(:ticket, department_id: department)

    expect(controller.ticket).to be_a(Ticket)
    expect(controller.ticket.aasm_state).to eq('waiting_for_staff')
    expect(controller.ticket).to be_persisted
  end

  it 'redirects to the created ticket' do
    post :create, ticket: attributes_for(:ticket, department_id: department)

    expect(response).to redirect_to(Ticket.last)
    expect(flash[:success]).to eq('Ticket was created successfully')
  end
end

RSpec.shared_examples 'customer_create_reply' do
  it 'redirects to root_path' do
    expect { post :create, reply: attributes_for(:reply), ticket_id: ticket }.to change(Reply, :count).by(0)
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('You are not authorized to access this page.')
  end
end

RSpec.shared_examples 'customer_change_status' do
  it 'redirects to root_path' do
    expect { patch :change_status, id: ticket_1, ticket: ticket_1.attributes.merge(aasm_state: 'waiting_for_customer') }.to change(Reply, :count).by(0)
    ticket_1.reload
    expect(ticket_1.aasm_state).to eq('waiting_for_staff')
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('You are not authorized to access this page.')
  end
end

RSpec.shared_examples 'customer_assignee_status' do
  it 'redirects to root_path' do
    expect { patch :change_assignee, id: ticket_1, ticket: ticket_1.attributes.merge(employee_id: employee) }.to change(Reply, :count).by(0)
    ticket_1.reload
    expect(ticket_1.employee).to be_nil
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('You are not authorized to access this page.')
  end
end