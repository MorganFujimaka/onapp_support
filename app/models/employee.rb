class Employee < ActiveRecord::Base
  has_many :replies, dependent: :destroy
  has_one :user, as: :role, dependent: :destroy
  belongs_to :department

  delegate :username, to: :user
end
