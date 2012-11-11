class YelpCategoriesController < ApplicationController
  # GET /yelp_categories
  # GET /yelp_categories.json
  def index
    @yelp_categories = YelpCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @yelp_categories }
    end
  end

  # GET /yelp_categories/1
  # GET /yelp_categories/1.json
  def show
    @yelp_category = YelpCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @yelp_category }
    end
  end

  # GET /yelp_categories/new
  # GET /yelp_categories/new.json
  def new
    @yelp_category = YelpCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @yelp_category }
    end
  end

  # GET /yelp_categories/1/edit
  def edit
    @yelp_category = YelpCategory.find(params[:id])
  end

  # POST /yelp_categories
  # POST /yelp_categories.json
  def create
    @yelp_category = YelpCategory.new(params[:yelp_category])

    respond_to do |format|
      if @yelp_category.save
        format.html { redirect_to @yelp_category, notice: 'Yelp category was successfully created.' }
        format.json { render json: @yelp_category, status: :created, location: @yelp_category }
      else
        format.html { render action: "new" }
        format.json { render json: @yelp_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /yelp_categories/1
  # PUT /yelp_categories/1.json
  def update
    @yelp_category = YelpCategory.find(params[:id])

    respond_to do |format|
      if @yelp_category.update_attributes(params[:yelp_category])
        format.html { redirect_to @yelp_category, notice: 'Yelp category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @yelp_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yelp_categories/1
  # DELETE /yelp_categories/1.json
  def destroy
    @yelp_category = YelpCategory.find(params[:id])
    @yelp_category.destroy

    respond_to do |format|
      format.html { redirect_to yelp_categories_url }
      format.json { head :no_content }
    end
  end
end
