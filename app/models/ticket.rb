require 'elasticsearch/model'

class Ticket < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include AASM

  aasm whiny_transitions: false do
    state :waiting_for_staff, initial: true
    state :waiting_for_customer
    state :on_hold
    state :cancelled, after_enter: :reset_employee
    state :completed, after_enter: :reset_employee

    event :waiting_for_staff do
      transitions to: :waiting_for_staff
    end

    event :waiting_for_customer do
      transitions to: :waiting_for_customer
    end

    event :on_hold do
      transitions to: :on_hold
    end

    event :cancel do
      transitions to: :cancelled
    end

    event :complete do
      transitions to: :completed
    end
  end

  before_create :assign_uref

  has_many :replies, dependent: :destroy
  belongs_to :department
  belongs_to :employee

  delegate :username, to: :employee

  validates :customer_name, :customer_email, :subject, :body, :department_id, presence: true
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  scope :newest_first, -> { order('created_at desc') }
  scope :by_status, -> status do
    case status
    when 'new_tickets'     then waiting_for_staff
    when 'open_tickets'    then waiting_for_customer
    when 'on_hold_tickets' then on_hold
    when 'closed_tickets'  then where(aasm_state: [:cancelled, :completed])
    end  
  end

  def self.states_with_events
    aasm.states.map(&:name).zip(Ticket.aasm.events.map(&:name)).to_h
  end

  private

  def assign_uref
    begin
      self.uref = generate_uref
    end while Ticket.exists?(uref: uref)
  end

  def generate_uref
    "#{random_capital_chars(3)}-#{random_hex(1)}-#{random_capital_chars(3)}-#{random_hex(1)}-#{random_capital_chars(3)}"
  end

  def random_capital_chars(quantity)
    ('A'..'Z').to_a.sample(quantity).join
  end

  def random_hex(quantity)
    SecureRandom.hex(quantity)
  end

  def reset_employee
    self.update(employee_id: nil)
  end
end

Ticket.import force: true