module TicketsHelper
  def ticket_urefs
    content_tag(:div, id: 'urefs', class: 'hidden') do
      Ticket.pluck(:uref).join(', ').html_safe
    end
  end
end
