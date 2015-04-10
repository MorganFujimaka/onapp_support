RSpec.shared_examples 'guest_edit_ticket' do
  it 'redirects to root path' do
    get :edit, id: ticket_1

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('You are not authorized to access this page.')
  end  
end

RSpec.shared_examples 'guest_update_ticket' do
  it 'redirects to root path' do
    patch :update, id: ticket_1

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('You are not authorized to access this page.')
  end  
end