# frozen_string_literal: true

require 'active_record'
require './utils'

module IdsOfAllDependencies
  def ids_of_all_dependencies(to_filter={})
    result = { main: {}, filtered_out: {} }
    self_symbol = self.class.name.underscore.to_sym

    self.class.reflect_on_all_associations.map do |association|
      next if association.macro == :belongs_to
      symbol = association.klass.name.underscore.to_sym
      context = { to_filter: to_filter, self_symbol: self_symbol, association: association }

      self.send(association.name).map(&:id).map do |id|
        hash_to_use = get_hash_to_use(result, context)
        hash_to_use[symbol] = [] if hash_to_use[symbol].nil?
        hash_to_use[symbol] << id
      end
      result = get_result_with_grandchildren_hashes(result, context)
    end

    result
  end

  private

  def get_result_with_grandchildren_hashes(result, context)
    hashes = get_grandchildren_hashes(context)
    main = hashes.map { |hash| hash[:main] }
    filtered_out = hashes.map { |hash| hash[:filtered_out] }

    result[:main] = Utils.uniquely_join_hashes_of_arrays(result[:main], *main)
    result[:filtered_out] = Utils.uniquely_join_hashes_of_arrays(result[:filtered_out], *filtered_out)
    result
  end

  def get_grandchildren_hashes(context)
    association = context[:association]
    to_filter = context[:to_filter]

    self.send(association.name).map do |model|
      next if should_be_filtered?(**context)
      model.ids_of_all_dependencies(to_filter)
    end.compact
  end

  def get_hash_to_use(result, context)
    symbol = should_be_filtered?(**context) ? :filtered_out : :main
    result[symbol]
  end

  def should_be_filtered?(to_filter:, self_symbol:, association:)
    arr = to_filter[self_symbol]
    arr.present? && arr.any? { |a| a == association.name }
  end
end

# Model class
class Model < ActiveRecord::Base
  include IdsOfAllDependencies

  self.abstract_class = true

  def attributes_without_id
    self.attributes.reject{|k, v| k == "id"}
  end
end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'abuse', 'abuses'
end
