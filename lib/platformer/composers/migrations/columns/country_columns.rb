# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Columns
        # Add all country columns to their respective tables within DynamicMigrations
        class CountryColumns < FieldParser
          # for each time the :country_field DSL was used on this Model
          for_field :country_field do |name:, database:, table:, array:, default:, comment_text:, allow_null:|
            enum_type_name = database.find_or_create_shared_enum Constants::ISO::CountryCode

            # update the dynamic documentation
            description <<~DESCRIPTION
              Update DynamicMigrations and add an #{array ? "array of countrys" : "country"}
              column named `#{name}` to the `#{table.schema.name}'.'#{table.name}` table.
              #{allow_null ? "This column can be null." : ""}. The column type is
              `#{enum_type_name}`. #{Constants::ISO::CountryCode.description}
            DESCRIPTION

            # The data type of the column.
            data_type = array ? :"#{enum_type_name}[]" : enum_type_name

            # add the column to the DynamicMigrations table
            table.add_column name, data_type.to_sym, null: allow_null, default: default, description: comment_text
          end
        end
      end
    end
  end
end
