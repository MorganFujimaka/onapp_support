class RepliesController < ApplicationController
  authorize_resource
  
  expose(:reply, attributes: :reply_params)
  expose(:replies)
  expose(:ticket)

  def create
    reply.ticket_id = params[:ticket_id]
    reply.employee = current_user.role
    if reply.save
      redirect_to ticket, success: 'Reply was added successfully'
    else
      render 'tickets/show'
    end
  end

  private

  def reply_params
    params.require(:reply).permit(:body)
  end
end
