class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable
         
  has_one :employee, dependent: :destroy
  has_many :replies, dependent: :destroy

  def employee?
    self.role == 'employee'
  end

  def customer?
    self.role == 'customer'
  end
end
