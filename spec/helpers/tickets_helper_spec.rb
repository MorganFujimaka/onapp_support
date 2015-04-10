require 'rails_helper'

RSpec.describe TicketsHelper, type: :helper do
  describe '#ticket_urefs' do
    it 'returns hidden div with ticket urefs' do
      ticket_1 = create :ticket
      ticket_2 = create :ticket

      expect(helper.ticket_urefs).to eq("<div id=\"urefs\" class=\"hidden\">#{ticket_1.uref}, #{ticket_2.uref}</div>")
    end
  end
end
