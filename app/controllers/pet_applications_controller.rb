class PetApplicationsController < ApplicationController
  def new
    @dogs = Pet.all
  end

  def create

    params[:desired_dogs] = params[:desired_dogs].reject(&:blank?) #get rid of empty string from checkmark
    pets = Pet.where(id: params[:desired_dogs])
    application = Application.create(application_params)
    pets.each do |c|
      PetApplication.create(application: application, pet_id: c.id)
    end
    redirect_to "/pets/application/#{application.id}"
  end

  def show
    @application = PetApplication.find(params[:id])
  end

  private
    def application_params
      params.permit(:name, :street_address, :city, :state, :zipcode, :description, :desired_dogs)
    end
end
