class GrainsController < AuthorizedController
  before_action :set_grain, only: %i[show edit update destroy]
  before_action :set_grains, only: %i[index export export_outlines]

  # GET /graves or /graves.json
  def index
    @grains_pagy, @grains = pagy(@grains)
    @pagination = pagy_metadata(@grains_pagy)
  end

  def export_outlines
    csv_data = CSV.generate do |csv|
      figures = @grains.map { [_1.dorsal, _1.lateral, _1.ventral, _1.ts] }.flatten.compact

      figures.each do |figure|
        contour = figure.contour.chunk_while { |a, b| a == b }.map(&:first)
        csv << ["#{figure.grain.identifier} - #{figure.view}", contour].flatten
      end
    end
    send_data csv_data, filename: "outlines.csv"
  end

  def export
    table = TableBuilder.new.build(@grains)

    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: "Grains") do |sheet|
      table.each { |row| sheet.add_row row }
    end

    send_data p.to_stream.read, :filename => 'grains.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
  end

  def orientations
    tag_id = Tag.find_by(name: params[:name])
    @skeleton_angles = Site.includes(
      graves: [:spines, :arrow]
    ).all.to_a.map do |site|
      # 3 = corded ware
      # 2 = bell beaker

      spines = site.graves.joins(:tags).where(tags: {id: tag_id}).flat_map do |grave|
        grave.spines
      end

      angles = Stats.all_spine_angles(spines).to_a
      angles
    end.filter do |grave_data|
      grave_data.sum > 0
    end.flatten
  end

  def show
  end

  def root
    @no_box = true

    @skeleton_angles = Site.includes(
      graves: [:spines, :arrow]
    ).all.to_a.map do |site|
      spines = site.graves.flat_map do |grave|
        grave.spines
      end

      angles = Stats.spine_angles(spines)

      {
        site: site,
        angles:
      }
    end.filter do |grave_data|
      grave_data[:angles].values.sum > 0
    end
  end

  def stats
  end

  # GET /graves/new
  def new
    @grave = Grave.new
  end

  # GET /graves/1/edit
  def edit
    @no_box = true
  end

  # POST /graves or /graves.json
  def create
    @grave = Grave.new(grafe_params)

    respond_to do |format|
      if @grave.save
        format.html { redirect_to grafe_url(@grafe), notice: "Grave was successfully created." }
        format.json { render :show, status: :created, location: @grafe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grafe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /graves/1 or /graves/1.json
  def update
    Grave.transaction do
      Figure.update(params[:figures].keys, params[:figures].values).reject { |p| p.errors.empty? }

      figures = Figure.where(id: params[:figures].keys)
      GraveSize.new.run(figures)
      AnalyzeScales.new.run(figures)
    end

    redirect_to edit_grave_path(@grave)
  end

  # DELETE /graves/1 or /graves/1.json
  def destroy
    @grave.delete

    respond_to do |format|
      format.html { redirect_to grave_update_grave_path(Grave.order(:id).where("id > ?", @grave.id).first || @grave.last, :set_grave_data), notice: "Grave was successfully removed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grain
    @grain = Grain.find(params[:id])
  end

  def set_grains
    @grains = Grain.order(:identifier)
    if params[:site_id].present? && params[:site_id] != "undefined" && params[:site_id] != "null"
      @grains = @grains.where(site_id: params[:site_id])
    end

    if params[:upload_id].present? && params[:upload_id] != "undefined" && params[:upload_id] != "null"
      @grains = @grains.where(upload_id: params[:upload_id])
    end

    if params[:species_id].present? && params[:species_id] != "undefined"
      @grains = @grains.where(strain_id: params[:species_id])
    end
  end

  # Only allow a list of trusted parameters through.
  def grave_params
    params.require(:grave).permit(:arrowAngle, :site_id, figures: %i[id type_name x1 x2 y1 y2])
  end
end
