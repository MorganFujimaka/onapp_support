class RepliesController < ApplicationController
  respond_to :html
  authorize_resource
  
  expose(:reply, attributes: :reply_params)
  expose(:replies)
  expose(:ticket)

  def create
    reply.ticket_id = params[:ticket_id]
    reply.employee = current_user.role
    respond_with ticket do |format|
      if reply.save
        flash[:success] = 'Reply was added successfully'
      else
        format.html { render 'tickets/show' }
      end
    end
  end

  private

  def reply_params
    params.require(:reply).permit(:body)
  end
end
