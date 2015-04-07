module TicketsHelper
  def open_ticket?
    !%w(cancelled completed).include?(ticket.aasm_state)
  end

  def ticket_urefs
    content_tag(:div, id: 'urefs', class: 'hidden') do
      Ticket.pluck(:uref).join(', ').html_safe
    end
  end
end
