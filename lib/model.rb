# frozen_string_literal: true

require 'active_record'
require 'ids_of_all_dependencies'
require 'nullify_dependencies'

class Model < ActiveRecord::Base
  include IdsOfAllDependencies
  include NullifyDependencies

  self.abstract_class = true

  def attributes_without_id
    self.attributes.reject{|k, v| k == "id"}
  end

  def self.get_model(name)
    self.subclasses.find{ |m| m.name == name.to_s.camelcase }
  end

  def self.get_model_by_table_name(name)
    self.subclasses.find{ |m| m.table_name == name.to_s }
  end

  def self.get_ids_of_entries_of_all_subclasses
    self.subclasses.map do |subclass|
      [subclass.name, subclass.all.map(&:id)] if subclass.any?
    end.compact.to_h
  end

  def self.get_sum_of_rows_of_all_subclasses
    self.subclasses.map do |subclass|
      subclass.all.size
    end.reduce(:+)
  end
end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'abuse', 'abuses'
end
