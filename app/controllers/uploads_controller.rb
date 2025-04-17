class UploadsController < AuthorizedController
  before_action :set_publication, only: %i[radar update_tags assign_tags update_site assign_site progress summary show edit update destroy stats]

  # GET /publications or /publications.json
  def index
    @publications = Upload.accessible_by(current_ability)

    @publications = if params[:sort] == "title:asc"
      @publications.order("title ASC NULLS LAST")
    elsif params[:sort] == "title:desc"
      @publications.order("title DESC NULLS LAST")
    elsif params[:sort] == "author:desc"
      @publications.order("author DESC NULLS LAST")
    elsif params[:sort] == "author:asc"
      @publications.order("author ASC NULLS LAST")
    elsif params[:sort] == "year:asc"
      @publications.order("year ASC NULLS LAST")
    elsif params[:sort] == "year:desc"
      @publications.order("year DESC NULLS LAST")
    else
      @publications.order(:created_at)
    end
  end

  # GET /publications/1 or /publications/1.json
  def show
    @publication
  end

  def assign_site
  end

  def assign_tags
  end

  def update_site
    @publication.figures.update_all(site_id: params[:site][:site_id])

    redirect_to publications_path
  end

  def update_tags
    tags = params[:tags].permit!.to_h[:tags].filter { !_1.blank? }.map do |tag_id|
      Tag.find(tag_id)
    end

    @publication.figures.where(type: "Grave").find_each do |grave|
      grave.tags = tags
      grave.save!
    end

    redirect_to publications_path
  end

  def summary
    @data = @publication.figures.group(:type).count
      .map do |type, value|
        [if type == "Kurgan"
           "Burial Mound"
         elsif type == "Oxcal"
           "OxCal Diagram"
         elsif type == "Arrow"
           "Orientation Arrow"
         else
           type
         end, value]
      end.to_h
  end

  def radar
    @skeleton_angles = Stats.spine_angles(@publication.figures.where(type: "Spine").includes(grave: :arrow))
  end

  def stats # rubocop:disable Metrics/AbcSize
    marked_items = params.dig(:compare, :special_mark_graves)&.split("\n")&.map(&:to_i) || []
    @excluded_graves = params.dig(:compare, :exclude_graves)&.split("\n")&.map(&:to_i) || []
    @no_box = true
    graves = @publication.figures.where(type: "Grave").where.not(id: @excluded_graves)
    @skeleton_per_grave_type = graves.includes(:skeleton_figures).map { _1.skeleton_figures.length }.tally
    @skeleton_angles = Stats.spine_angles(@publication.figures.where(type: "Spine").includes(grave: :arrow))
    @grave_angles = Stats.grave_angles(graves.includes(:arrow))
    set_compare_graves

    @publications = [@publication, *@other_publications].reverse

    @outlines_pca_data, @outline_pca = Stats.outlines_pca([@publication, *@other_publications].reverse, special_objects: marked_items, excluded: @excluded_graves)
    @variances = Stats.pca_variance([@publication, *@other_publications].reverse, marked: marked_items, excluded: @excluded_graves)
    # @outline_variance_ratio = @outline_pca.explained_variance_ratio.to_a
    @outline_variance_ratio = []
    @graves_pca, @pca = Stats.graves_pca([@publication, *@other_publications].reverse, special_objects: marked_items,
      excluded: @excluded_graves)

    # @graves_pca_chart = Stats.pca_chart(@graves_pca)

    @heatmap_data = ArtefactsHeatmap.new.run(@publication)

    @outlines_data, _ = Stats.outlines_efd([@publication, *@other_publications].reverse, excluded: @excluded_graves)

    # upgma_result = Stats.upgma(@outlines_data)
    # @upgma_figure = Stats.upgma_figure(upgma_result)

    # @cluster_upgma_chart = Stats.cluster_scatter_chart(@outlines_data, upgma_result)

    # ward_result = Stats.ward(@outlines_data)
    # @ward_figure = Stats.upgma_figure(ward_result)

    # @cluster_ward_chart = Stats.cluster_scatter_chart(@outlines_data, ward_result)

    # @clustering_result = Upgma.cluster(@outlines_pca_data.map do |item|
    #   item[:data].map { [_1[:x], _1[:y]] }
    # end.flatten(1).map { [_1] }, 10).map do |cluster|
    #   {
    #     data: cluster.map { { x: _1[0], y: _1[1] } }
    #   }
    # end

    # @efd_pca_chart = Stats.pca_chart(@outlines_pca_data)
    @colors = [
      [209, 41, 41],
      [129, 239, 19],
      [77, 209, 209],
      [115, 10, 219]
    ]
    @hex_colors = @colors.map do |color|
      "##{color[0].to_s(16)}#{color[1].to_s(16)}#{color[2].to_s(16)}"
    end
  end

  # GET /publications/new
  def new
    @upload = Upload.new
  end

  # GET /publications/1/edit
  def edit
  end

  def analyze
    @publication = Publication.find(params[:id])

    AnalyzePublicationJob.perform_later Publication.first
  end

  # POST /publications or /publications.json
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    name = publication_params[:name]
    if name.empty?
      name = publication_params[:zip].original_filename.gsub(".pdf", "")
    end

    @upload = Upload.new({
      name: name,
      site: publication_params[:site],
      strain_id: publication_params[:strain],
      view: publication_params[:view]
    })

    respond_to do |format|
      if @publication.save
        AnalyzePublicationJob.perform_later(@upload)

        format.html do
          redirect_to progress_publication_path(@upload)
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def progress
  end

  # PATCH/PUT /publications/1 or /publications/1.json
  def update
    respond_to do |format|
      if @publication.update(publication_params)
        format.html { redirect_to publications_path, notice: "Publication was successfully updated." }
        format.json { render :show, status: :ok, location: @publication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publications/1 or /publications/1.json
  def destroy
    @publication.destroy!

    respond_to do |format|
      format.html { redirect_to publications_url, notice: "Publication was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publication
    @publication = Publication
      .select(:title, :author, :id, :year, :user_id, :public)
      .find(params[:id] || params[:publication_id])
  end

  def set_compare_graves
    @other_publications = params
      .dig(:compare, :publication_id)
      &.take(4)
      &.map { Publication.includes(:figures).find(_1) if _1.present? }
      &.compact
  end

  # Only allow a list of trusted parameters through.
  def publication_params
    params.require(:publication).permit(:zip, :name, :site, :strain, :view)
  end
end
