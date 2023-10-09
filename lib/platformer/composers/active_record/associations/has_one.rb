# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Associations
        class HasOne < Parsers::Models
          for_dsl :has_one do |active_record_class:, module_name:, name:, model:, through:, local_columns:, foreign_columns:|
            foreign_model_class_name = model&.active_record_class&.name || "#{module_name}::#{name.to_s.classify}Model"

            add_documentation <<~DESCRIPTION
              Add a has one association between this model and #{foreign_model_class_name}.
            DESCRIPTION

            if local_columns.any? || foreign_columns.any?
              if through
                raise "not currently supported"
              end
              # a map of the local and foreign column names used to resolve this association
              column_name_map = {}
              foreign_columns.each_with_index do |column_name, i|
                column_name_map[column_name] = local_columns[i]
              end

              # find the foreign model using these arguments
              active_record_class.install_method name do
                # the column names on the remote model with the corresponding values from the local model
                finder_args = {}
                column_name_map.each do |remote_column_name, local_column_name|
                  finder_args[remote_column_name] = send(local_column_name)
                end

                foreign_model_class_name.consantize.find_by finder_args
              end

            else
              opts = {}
              opts[:class_name] = foreign_model_class_name
              if through
                opts[:through] = through
              end
              active_record_class.has_one name, **opts
            end
          end
        end
      end
    end
  end
end
