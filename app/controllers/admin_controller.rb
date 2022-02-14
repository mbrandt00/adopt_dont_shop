class AdminController < ApplicationController
  def index
    @shelters = Shelter.order_alphabetical_descending
    @pending = Shelter.pending_applications
  end

  def show
    @pending_app = Application.find(params[:id])
    @approved_pets = PetApplication.find_approved_pets(@pending_app)
    @rejected_pets = PetApplication.find_rejected_pets(@pending_app)
    @undetermined_pets = PetApplication.find_undecided_pets(@pending_app)
    @pending_app.Approved! if @rejected_pets.empty? && @undetermined_pets.empty?
    @pending_app.Rejected! if @rejected_pets.any?
  end

  def update
    pending_app = Application.find(params[:application_id])
    pet = Pet.find(params[:pet_id])
    pet_application = PetApplication.find_joins_row(pending_app, pet).first
    if params[:descision] == 'accepted'
      pet_application.Accepted!
      pet.adoptable = false
      pet.save
    elsif params[:descision] == 'rejected'
      pet_application.Rejected!
    end
    redirect_to "/admin/applications/#{pending_app.id}"
  end
end
