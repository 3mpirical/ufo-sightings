class Api::SightingsController < ApiController
  before_action :set_sighting, only: [:show, :update, :destroy]

  def index
    sightings = Sighting.filter_by(sighting_query_params)
    options = parse_pagination_meta(sightings, params[:limit], params[:page])
    paginated_sightings = sightings.order_by(pagination_query_params)
    render(json: SightingSerializer.new(paginated_sightings, options))
  end

  def show
    render(json: SightingSerializer.new(@sighting))
  end

  def create
    sighting = Sighting.new(sighting_params)

    if sighting.save
      render(json: SightingSerializer.new(sighting))
    else
      render_error(sighting.errors.messages, 422)
    end
  end

  def update
    if @sighting.update(sighting_params)
      render(json: SightingSerializer.new(@sighting))
    else
      render_error(@sighting.errors.messages, 422)
    end
  end

  def destroy
    @sighting.destroy

    if @sighting.destroyed?
      render(json: messages(:destroyed))
    else
      render_error(messages(:destroy_failed), 422)
    end
  end

  private

  def set_sighting
    @sighting = Sighting.find(params[:id])
  end

  def sighting_query_params
    params.permit(
      :shape,
      :duration_seconds,
      :city,
      :state,
      :radius,
      :latitude,
      :longitude
    )
  end

  def sighting_params
    parameters = params.permit(:sighting_date, :shape, :comments, :city, :state)
    parameters.merge!(duration_params)
    parameters.merge!(lonlat_param)
    parameters
  end

  def duration_params
    {
      duration_seconds: params[:duration].to_i * 60,
      duration_string: params[:duration] + " minutes"
    }
  end

  def lonlat_param
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    { lonlat: factory.point(params[:longitude], params[:latitude]) }
  end
end
