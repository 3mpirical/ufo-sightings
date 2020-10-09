module Filterable
  extend ActiveSupport::Concern
  require "rainbow"

  included do
    base = self

    scope :filter_by, -> (filters) do
      Filterable.filter_results(all, filters, base)
    end
  end

  class_methods do
    def filterable_by(scope_name, lambda)
      method_name = "filter_by_#{scope_name}"
      if respond_to?(method_name)
        Rails.logger.error(Rainbow("FILTERABLE CONCERN: '#{scope_name}' filter is already declared").red)
      else
        scope(method_name, lambda)
      end
    end

    def filterable_by_with_params(scope_name, lambda)
      method_name = "filter_by_#{scope_name}_with_params"
      if respond_to?(method_name)
        Rails.logger.error(Rainbow("FILTERABLE CONCERN: '#{scope_name}' filter is already declared").red)
      else
        scope(method_name, lambda)
      end
    end

    def filterable_data(data_name)
      method_name = "filter_data_#{data_name}"
      if respond_to?(method_name)
        Rails.logger.error(Rainbow("FILTERABLE CONCERN: '#{scope_name}' data is already declared").red)
      else
        scope(method_name, -> {})
      end
    end
  end

  def self.filter_results(results, filters, base)
    filters.each do |key, value|
      results = Filterable.check_args_and_send(results, key, value, filters, base)
    end
    results
  end

  def self.check_args_and_send(results, scope_name, value, filters, base)
    if base.respond_to?("filter_by_#{scope_name}")
      results.public_send("filter_by_#{scope_name}", value)
    elsif base.respond_to?("filter_by_#{scope_name}_with_params")
      results.public_send("filter_by_#{scope_name}_with_params", value, filters)
    elsif base.respond_to?("filter_data_#{scope_name}")
      results
    else
      Rails.logger.error(Rainbow("FILTERABLE CONCERN: '#{scope_name}' filter is not valid").red)
      results
    end
  end
end
