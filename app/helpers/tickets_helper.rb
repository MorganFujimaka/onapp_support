module TicketsHelper
  def open_ticket?
    !%w(cancelled completed).include?(ticket.aasm_state)
  end

  def author?
    ticket.customer_email == current_user.email
  end
end
