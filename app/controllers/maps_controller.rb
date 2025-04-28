class MapsController < AuthorizedController
  def index
    @sites = Site.all
  end
end
