class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i[ show edit update destroy ]

  # GET /microposts or /microposts.json
  def index
    @microposts = Micropost.all

    sort = params[:sort]

    if sort == 'date'
      @microposts = Micropost.order(created_at: :desc)
    else if sort == 'type_ask'
      @microposts = Micropost.find_by(url: [nil, ""])
      end
    end

  end

  # GET /microposts/1 or /microposts/1.json
  def show
  end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit
  end

  # POST /microposts or /microposts.json
  def create
    @micropost = Micropost.new(micropost_params)
    @micropost.user_id = 0

    respond_to do |format|
      if micropost_params[:url] != "" && Micropost.exists?(url: micropost_params[:url])
        @micropost = Micropost.find_by(url: micropost_params[:url])
        format.html { redirect_to  @micropost, notice: "The url provided is already used on another micropost." }
        # CAMBIAR ^ para que redireccione a la vista
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
      if @micropost.save
        format.html { redirect_to  microposts_url(:sort => "date"), notice: "Micropost was successfully created." }
        format.json { render :show, status: :created, location: @micropost }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /microposts/1 or /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html { redirect_to micropost_url(@micropost), notice: "Micropost was successfully updated." }
        format.json { render :show, status: :ok, location: @micropost }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @micropost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /microposts/1 or /microposts/1.json
  def destroy
    @micropost.destroy

    respond_to do |format|
      format.html { redirect_to microposts_url, notice: "Micropost was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def micropost_params
      params.require(:micropost).permit(:title, :url, :text, :user_id)
    end
end
