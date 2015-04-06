class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.employee?
      can :create, Reply
      can [:read, :change_status, :change_assignee], Ticket
    elsif user.customer?
      can [:read, :create], Ticket
      can :update, Ticket, customer_email: user.email
    else
      can :read, :all
      can :create, Ticket
    end
  end
end
