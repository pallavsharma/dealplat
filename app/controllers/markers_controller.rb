class MarkersController < ApplicationController
  load_and_authorize_resource

  respond_to :json

  # GET /markers
  # GET /markers.json
  def index
    respond_with @markers
    #respond_with @markers do |format|
    #  format.json { render json: @markers }
    #end
  end

  # GET /markers/1
  # GET /markers/1.json
  def show
    respond_with @marker
  end

  # GET /markers/new
  def new
  end

  # GET /markers/1/edit
  def edit
  end

  # POST /markers
  # POST /markers.json
  def create
    @marker.save
    respond_with @marker do |format|
      format.json { render json: @marker }
    end
  end

  # PATCH/PUT /markers/1
  # PATCH/PUT /markers/1.json
  def update
    @marker.update(marker_params)
    respond_with @marker
  end

  # DELETE /markers/1
  # DELETE /markers/1.json
  def destroy
    @marker.destroy

  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def marker_params
      params.require(:marker).permit(:latitude, :longitude, :marker_category_id, :title)
    end

end
