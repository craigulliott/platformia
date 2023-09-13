module Platformer
  module DSLs
    module Models
      module PrimaryKey
        def self.included klass
          klass.define_dsl :primary_key do
            description <<~DESCRIPTION
              Add a primary key to this table.
            DESCRIPTION

            optional :column_names, :symbol, array: true do
              import_shared :snake_case_name_validator

              description <<~DESCRIPTION
                If provided, then these existing columns will be used to build the primary key.
                If ommited, then a default column named `id` with a datatype of `uuid` will be added
                automatically and used for the primary key.
              DESCRIPTION
            end

            import_shared :field_comment
          end
        end
      end
    end
  end
end
