class ApplicationsController < ApplicationController


  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/pets/applications/#{application.id}"
    else
      flash[:notice] = "Missing Input!"
      render :new
    end
  end

  def new
  end

  def update
    application = Application.find(params[:applicationid])
    if params[:petid]
      pet = Pet.find(params[:petid])
      application.adopt(pet)
    elsif params[:commit] == 'Submit Application'
      application.update(application_params)
      application.Pending!
    end
    redirect_to "/pets/applications/#{application.id}"
  end



  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      @pets = Pet.sorted(params[:search])
    else
      @pets = Pet.all
    end
  end

  private
    def application_params
      params.permit(:name, :street_address, :city, :state, :zipcode, :description)
    end

end
