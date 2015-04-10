class TicketsController < ApplicationController
  authorize_resource

  after_filter :create_reply, only: [:change_status, :change_assignee]

  expose(:ticket, attributes: :ticket_params)
  expose(:tickets) { Ticket.by_status(params[:status]).includes(:department).paginate(page: params[:page], per_page: 5) }
  expose(:reply)   { Reply.new }
  expose(:replies) { Reply.includes(:user) }

  def create
    if ticket.save
      CustomerMailer.new_ticket_email(ticket).deliver_now
      redirect_to ticket, success: 'Ticket was created successfully'
    else
      render 'new'
    end
  end

  def edit
    authorize! :edit, ticket
  end

  def update
    if ticket.save
      ticket.waiting_for_staff!
      redirect_to ticket, success: 'Ticket was updated successfully'
    else
      render 'edit'
    end
  end

  def change_status
    if ticket.send(Ticket.states_with_events[ticket_params[:aasm_state].to_sym]) && ticket.save
      new_status = ticket.aasm_state.humanize
      @reply_body = "Status was changed to #{new_status}"
      redirect_to ticket, success: 'Status was changed successfully'
    else
      flash.now[:alert] = 'Unable to change status. Please try again'
      render 'tickets/show'
    end
  end

  def change_assignee
    assignee = Employee.find(ticket_params[:employee_id])
    if ticket.update(employee: assignee)
      @reply_body = "Ticket was assigned to #{assignee.username}"
      redirect_to ticket, success: 'Assignee was changed successfully'
    else
      flash.now[:alert] = 'Unable to change assignee. Please try again'
      render 'tickets/show'
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:customer_name, :customer_email, :employee_id, :aasm_state,
                                   :subject, :department_id, :body)
  end

  def create_reply
    Reply.create(employee: current_user.role, ticket: ticket, body: @reply_body)
  end
end
