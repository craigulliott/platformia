# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all integer columns to their respective tables within DynamicMigrations
        class Integer < Parsers::Models::ForFields
          for_field :integer_field do |name:, table:, bigint:, array:, database_default:, description:, allow_null:|
            # update the dynamic documentation
            add_documentation <<~DESCRIPTION
              Add an #{array ? "array of integers" : "integer"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}.
            DESCRIPTION

            # the data type of the column
            base_type = bigint ? :bigint : :integer
            data_type = array ? :"#{base_type}[]" : base_type

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: database_default, description: description
          end
        end
      end
    end
  end
end
