class ApiController < ActionController::API
  include Messages

  private

  def render_error(errors_params, status)
    render(
      json: {
        errors: errors_params.deep_transform_keys { |key| key.to_s.camelize(:lower) },
      },
      status: status
    )
  end

  def parse_pagination_meta(records, limit_param, page_param)
    # limit defaults to 15 if a page is set without a limit
    # and we don't want to accept limits less than or equal to zero.
    limit =
      if page_param && !limit_param
        15
      elsif limit_param.to_i <= 0
        nil
      else
        limit_param.to_i
      end

    count = records.length
    pages = limit.nil? ? 1 : (count.to_f / limit.to_i).ceil
    { meta: { count: count, pages: pages } }
  end

  def pagination_query_params
    params.permit(:order_by, :direction, :limit, :page)
  end
end