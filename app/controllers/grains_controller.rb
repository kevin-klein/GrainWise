class GrainsController < AuthorizedController
  before_action :set_grain, only: %i[show edit update destroy]

  # GET /graves or /graves.json
  def index
    grains = Grain.all
    # if params.dig(:search, :publication_id).present?
    #   grains = Grave
    #     .joins(page: :publication)
    #     .where({publication: {id: params.dig(:search, :publication_id)}})
    # end

    @grains = grains
      .includes(:scale, :site, :upload, upload_item: :image)

    if params.dig(:search, :site_id).present?
      @grains = @grains.where(site_id: params[:search][:site_id])
    end

    @grains = if params[:sort] == "area:desc"
      @grains.order("real_world_area DESC NULLS LAST")
    elsif params[:sort] == "area:asc"
      @grains.order("real_world_area ASC NULLS LAST")
    elsif params[:sort] == "perimeter:asc"
      @grains.order("real_world_perimeter ASC NULLS LAST")
    elsif params[:sort] == "perimeter:desc"
      @grains.order("real_world_perimeter DESC NULLS LAST")
    elsif params[:sort] == "width:desc"
      @grains.order("real_world_width DESC NULLS LAST")
    elsif params[:sort] == "width:asc"
      @grains.order("real_world_width ASC NULLS LAST")
    elsif params[:sort] == "length:asc"
      @grains.order("real_world_height ASC NULLS LAST")
    elsif params[:sort] == "length:desc"
      @grains.order("real_world_height DESC NULLS LAST")
    elsif params[:sort] == "id:asc"
      @grains.order("id ASC NULLS LAST")
    elsif params[:sort] == "id:desc"
      @grains.order("id DESC NULLS LAST")
    elsif params[:sort] == "depth:desc"
      @grains.order("real_world_depth DESC NULLS LAST")
    elsif params[:sort] == "depth:asc"
      @grains.order("real_world_depth DESC NULLS LAST")
    elsif params[:sort] == "site:asc"
      @grains.joins(:site).reorder("sites.name ASC NULLS LAST")
    elsif params[:sort] == "site:desc"
      @grains.joins(:site).reorder("sites.name DESC NULLS LAST")
    elsif params[:sort] == "publication:asc"
      @grains.joins(:publication).reorder("publications.author ASC NULLS LAST")
    elsif params[:sort] == "publication:desc"
      @grains.joins(:publication).reorder("publications.author DESC NULLS LAST")
    else
      @grains.reorder("figures.created_at")
    end

    @grains_pagy, @grains = pagy(@grains)
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

  # GET /graves/1 or /graves/1.json
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

  # Only allow a list of trusted parameters through.
  def grave_params
    params.require(:grave).permit(:arrowAngle, :site_id, figures: %i[id type_name x1 x2 y1 y2])
  end
end
