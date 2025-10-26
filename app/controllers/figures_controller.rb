class FiguresController < AuthorizedController
  skip_forgery_protection
  before_action :set_figure, only: %i[show edit preview update destroy]

  # GET /figures or /figures.json
  def index
    @figures = Figure.all
  end

  # GET /figures/1 or /figures/1.json
  def show
  end

  # GET /figures/new
  def new
    @figure = Figure.new
  end

  def preview
    @image = Vips::Image.new_from_buffer(@figure.page.image.data, "")
    @image = @image.crop(@figure.x1, @figure.y1, @figure.box_width, @figure.box_height)

    send_data @image.write_to_buffer(".jpg[Q=90]"), filename: "#{@figure.id}.jpg"
  end

  # GET /figures/1/edit
  def edit
  end

  # POST /figures or /figures.json
  def create
    @figure = Figure.new(figure_params)

    respond_to do |format|
      if @figure.save
        AnalyzeScales.new.run([@figure])
        format.html { redirect_to figure_url(@figure), notice: "Figure was successfully created." }
        format.json { render json: @figure }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @figure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /figures/1 or /figures/1.json
  def update
    respond_to do |format|
      if @figure.update(figure_params)
        AnalyzeScales.new.run([@figure])
        format.html { redirect_to figure_url(@figure), notice: "Figure was successfully updated." }
        format.json {
          render json: {
            figure: @figure,
            errorcode: 0,
            error: nil
          }
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @figure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /figures/1 or /figures/1.json
  def destroy
    @figure.delete

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Figure was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_figure
    @figure = Figure.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def figure_params
    params.require(:figure).permit(:parent_id, :x1, :x2, :y1, :y2, :type, :upload_item_id, :upload_id)
  end
end
