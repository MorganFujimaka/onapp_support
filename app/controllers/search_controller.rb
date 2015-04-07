class SearchController < ApplicationController
  def search
    if params[:q].nil?
      @tickets = []
    else
      @tickets = Ticket.search(params[:q][:search]).records.paginate(page: params[:page], per_page: 5)
    end
  end
end
