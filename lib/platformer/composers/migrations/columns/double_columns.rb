# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all double columns to their respective tables within DynamicMigrations
        class DoubleColumns < FieldParser
          for_field :double_field do |name:, table:, array:, default:, comment_text:, allow_null:|
            # update the dynamic documentation
            description <<~DESCRIPTION
              Update DynamicMigrations and add an #{array ? "array of double precisions" : "double precision"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}
            DESCRIPTION

            # The data type of the column. Where n is a precision value between 25 and 53, PostgreSQL
            # accepts float(n) and assumes the data type of `double precision`.
            data_type = array ? :"double precision[]" : :"double precision"

            # add the column to the DynamicMigrations table
            table.add_column name, data_type, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
