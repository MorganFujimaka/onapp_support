class Customer < ActiveRecord::Base
  has_one :user, as: :role, dependent: :destroy
end
