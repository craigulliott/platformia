module Platformer
  module Composers
    module Migrations
      module Associations
        class BelongsTo < Parsers::FinalModels
          for_dsl :belongs_to do |child_class:, foreign_model:, local_column_names:, foreign_column_names:, comment:, deferrable:, initially_deferred:, on_delete:, on_update:|
            local_table = child_class.table_structure
            foreign_table = foreign_model.table_structure

            allow_null = method_called?(:allow_null)

            description <<~DESCRIPTION
              Create an association between the `#{local_table.schema.name}'.'#{local_table.name}` table
              and the foreign `#{foreign_table.schema.name}'.'#{foreign_table.name}` table.
            DESCRIPTION

            # get (or build) the foreign columns (which also asserts that they exist)
            local_columns = []
            if local_column_names.empty?
              # generate the local column name based off the name of the foreign table
              column_name = :"#{foreign_table.name.to_s.singularize}_id"
              # add this column to the local table
              local_columns << local_table.add_column(column_name, :uuid, null: allow_null, description: <<~DESCRIPTION)
                #{comment}
                This table belongs to `#{foreign_table.schema.name}'.'#{foreign_table.name}` table.
              DESCRIPTION

              description <<~DESCRIPTION
                A uuid column named `#{column_name}` was automatically created on the local table.
              DESCRIPTION

            else
              local_column_names.each do |column_name|
                local_columns << local_table.column(column_name)
              end
            end

            # get the foreign columns (which also asserts that they exist)
            foreign_columns = []
            if foreign_column_names.empty?
              foreign_columns << foreign_table.column(:id)
            else
              foreign_column_names.each do |column_name|
                foreign_columns << foreign_table.column(column_name)
              end
            end

            local_column_descriptions = local_columns.map { |c| "#{c.name} (#{c.data_type})" }
            foreign_column_descriptions = foreign_columns.map { |c| "#{c.name} (#{c.data_type})" }

            description <<~DESCRIPTION
              The association is between the local columns #{local_column_descriptions.to_sentence}
              and the foreign columns #{foreign_column_descriptions.to_sentence}.
            DESCRIPTION

            # if these tables are in the same database then create a
            # foreign key constraint
            if local_table.schema.database == foreign_table.schema.database

              # the values we need for the foreign key constraint
              local_column_names = local_columns.map(&:name)
              foreign_schema_name = foreign_table.schema.name
              foreign_table_name = foreign_table.name
              foreign_column_names = foreign_columns.map(&:name)

              on_delete_action = on_delete || :no_action
              on_update_action = on_update || :no_action

              on_delete_action_name = on_delete_action.to_s.tr("_", " ").upcase
              on_update_action_name = on_update_action.to_s.tr("_", " ").upcase

              foreign_key_name = :"association_to_#{foreign_table.name}"

              options = {
                deferrable: deferrable,
                initially_deferred: initially_deferred,
                on_delete: on_delete_action,
                on_update: on_update_action,
                description: comment
              }

              description <<~DESCRIPTION
                A foreign key constraint named #{foreign_key_name} was created between these columns.
                The ON DELETE action is `#{on_delete_action_name}` and the ON UPDATE action is `#{on_update_action_name}`.
              DESCRIPTION

              if deferrable
                description <<~DESCRIPTION
                  This constraint is deferrable and is #{initially_deferred ? "" : "not "}deferred by default.
                DESCRIPTION
              else
                description <<~DESCRIPTION
                  This constraint is not deferrable.
                DESCRIPTION
              end

              # create the foreign key constraint
              local_table.add_foreign_key_constraint foreign_key_name, local_column_names, foreign_schema_name, foreign_table_name, foreign_column_names, **options
            else
              description <<~DESCRIPTION
                A foreign key constraint was not created because the tables are in different databases.
              DESCRIPTION
            end
          end
        end
      end
    end
  end
end