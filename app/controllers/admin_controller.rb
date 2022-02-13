class AdminController < ApplicationController
  def index
    @shelters = Shelter.order_alphabetical_descending
  end
end
