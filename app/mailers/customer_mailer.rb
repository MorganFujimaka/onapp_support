class CustomerMailer < ApplicationMailer
  default from: 'support@onappapp.com'

  def new_ticket_email(ticket)
    @uref = ticket.uref
    @url = ticket_url(ticket)
    mail to: ticket.customer_email, subject: "#{@uref} - Your ticket was added successfully"
  end

  def ticket_updates(reply)
    @uref = reply.ticket.uref
    @url = ticket_url(reply.ticket)
    @updates = reply.body
    mail to: reply.customer_email, subject: "#{@uref} - Your ticket was updated"
  end
end
