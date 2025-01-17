class AdminController < ApplicationController
  def index
    @shelters = Shelter.order_alphabetical_descending
    @pending = Shelter.pending_applications
  end

  def show
    @shelter = Shelter.find(params[:id])
    @require_action = Application.require_action(@shelter.id)
  end
end
