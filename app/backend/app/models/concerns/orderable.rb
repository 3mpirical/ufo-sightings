module Orderable
  extend ActiveSupport::Concern
  require "rainbow"
  @direction_whitelist = HashWithIndifferentAccess.new(asc: true, desc: true)

  included do
    scope :order_by, -> (filters) do
      results = all
      results = Orderable.order_results(results, filters)
      results = Orderable.paginate_results(results, filters)
      results
    end
  end

  class_methods do
    def orderable_by(*args)
      args.reverse_each do |item|
        Orderable.create_item_scope(self, item)
      end
    end
  end

  def self.create_item_scope(model, item)
    # the instance variable is not available within the block
    direction_whitelist = @direction_whitelist
    model.scope(
      "order_by_#{item}",
      -> (direction = :asc, filters) do
        order(item => direction) if direction_whitelist[direction]
      end
    )
  end

  def self.order_results(results, filters)
    order = filters[:order_by]
    direction = filters[:direction] || :asc
    if order
      results.public_send("order_by_#{order}", direction, filters)
    else
      results
    end
  end

  def self.paginate_results(results, filters)
    page = filters[:page] ? filters[:page].to_i : nil
    limit = filters[:limit] ? filters[:limit].to_i : nil
    if (page.is_a?(Integer) && page >= 0) || (limit.is_a?(Integer) && limit >= 0)
      results.page(page || 1).per(limit || 15)
    else
      results
    end
  end
end