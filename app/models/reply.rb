class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket

  validates :body, :ticket_id, presence: true

  after_save :send_email

  delegate :username, to: :user
  delegate :customer_email, to: :ticket

  private

  def send_email
    CustomerMailer.ticket_updates(self).deliver_now
  end
end
