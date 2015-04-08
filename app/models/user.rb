class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable
         
  belongs_to :role, polymorphic: true

  after_create :create_customer

  def employee?
    self.role_type == 'Employee'
  end

  def customer?
    self.role_type == 'Customer'
  end

  private

  def create_customer
    Customer.create.user = self unless self.role
  end
end
