class PetApplicationsController < ApplicationController

  def index
    @petapplications = PetApplication.all
  end

  def new
  end

  def create
    params[:desired_dogs] = params[:desired_dogs].reject(&:blank?).map(&:to_i) #get rid of empty string from checkmark
    pets = Pet.where(id: params[:desired_dogs])
    application = Application.new(application_params)
    if application.save && pets.present?
    pets.each do |c|
      PetApplication.create(application: application, pet_id: c.id)
    end
    redirect_to "/pets/applications/#{PetApplication.last.id}"
    else
      flash[:notice] = "Missing Input!"
      render :new
    end
  end

  def show
    @petapplication = PetApplication.find(params[:id])
  end

  private
    def application_params
      params.permit(:name, :street_address, :city, :state, :zipcode, :description)
    end
end
