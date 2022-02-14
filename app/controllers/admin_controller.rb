class AdminController < ApplicationController
  def index
    @shelters = Shelter.order_alphabetical_descending
    @pending = Shelter.pending_applications
  end

  def show

  end

end
