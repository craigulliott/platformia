# frozen_string_literal: true

module Platformer
  module Composers
    module Migrations
      module Coercions
        module Fields
          # install validations to assert that the empty_json_to_null coercion rules were followed
          class Json < Parsers::Models::ForFields
            for_fields :json_field do |name:, table:|
              column = table.column name

              for_method :empty_json_to_null do |method_name:, description:|
                add_documentation <<~DESCRIPTION
                  Update this models table (`#{column.table.schema.name}'.'#{column.table.name}`)
                  within DynamicMigrations and add a constraint to assert that the `#{column.name}`
                  column does not equal an empty json object. This is because this field has an
                  empty_json_to_null coercion on it, so empty jsons should have been converted to
                  null before saving.
                DESCRIPTION

                validation_name = :"#{column.name}_empty_json_nulled"

                # Add the validation to the table, assert that the value is not an
                # empty json, (which asserts that the empty_json_to_null coercion was
                # properly applied before it was saved).
                check_clause = <<~SQL
                  #{column.name} != '{}';
                SQL
                table.add_validation validation_name, [column.name], check_clause, description: <<~DESCRIPTION
                  #{description}
                  This validation asserts that the empty_json_to_null coercion has been applied to this field
                DESCRIPTION
              end
            end
          end
        end
      end
    end
  end
end
