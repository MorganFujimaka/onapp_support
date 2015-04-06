class Employee < ActiveRecord::Base
  belongs_to :user
  belongs_to :department

  delegate :username, to: :user
end
