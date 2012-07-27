class YelpInfosController < ApplicationController
  # GET /yelp_infos
  # GET /yelp_infos.json
  def index
    @yelp_infos = YelpInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @yelp_infos }
    end
  end

  # GET /yelp_infos/1
  # GET /yelp_infos/1.json
  def show
    @yelp_info = YelpInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @yelp_info }
    end
  end

  # GET /yelp_infos/new
  # GET /yelp_infos/new.json
  def new
    @yelp_info = YelpInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @yelp_info }
    end
  end

  # GET /yelp_infos/1/edit
  def edit
    @yelp_info = YelpInfo.find(params[:id])
  end

  # POST /yelp_infos
  # POST /yelp_infos.json
  def create
    @yelp_info = YelpInfo.new(params[:yelp_info])

    respond_to do |format|
      if @yelp_info.save
        format.html { redirect_to @yelp_info, notice: 'Yelp info was successfully created.' }
        format.json { render json: @yelp_info, status: :created, location: @yelp_info }
      else
        format.html { render action: "new" }
        format.json { render json: @yelp_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /yelp_infos/1
  # PUT /yelp_infos/1.json
  def update
    @yelp_info = YelpInfo.find(params[:id])

    respond_to do |format|
      if @yelp_info.update_attributes(params[:yelp_info])
        format.html { redirect_to @yelp_info, notice: 'Yelp info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @yelp_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yelp_infos/1
  # DELETE /yelp_infos/1.json
  def destroy
    @yelp_info = YelpInfo.find(params[:id])
    @yelp_info.destroy

    respond_to do |format|
      format.html { redirect_to yelp_infos_url }
      format.json { head :no_content }
    end
  end
end
