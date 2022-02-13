class AdminController < ApplicationController
  def index
    @shelters = Shelter.order_alphabetical_descending
    @pending = Shelter.pending_applications
  end

  def show
    @pending_app = Application.find(params[:id])
  end

  def update
    pending_app = Application.find(params[:application_id])
    pet = Pet.find(params[:pet_id])
    pending_app.Approved!
    pet.adoptable = false
    pet.save
    redirect_to "/admin/applications/#{pending_app.id}"
  end
end
