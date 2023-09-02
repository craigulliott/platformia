module Platformer
  module DSLs
    module Models
      module Fields
        module LanguageField
          def self.included klass
            klass.define_dsl :language_field do
              namespace :fields
              title "Add a Language field to your Model"
              description "Add a language field to this model."

              # Arguments
              #
              # an optional prefix for this fields name
              optional :prefix, :symbol do
                description <<~DESCRIPTION
                  An optional prefix to use for the name of this field. This prefix
                  will be prepended to the column names which back this model, and
                  to the presenter methods, graphql queries and mutations.
                DESCRIPTION
                validate_format(/\A[a-z]+(_[a-z]+)*\Z/)
              end

              # add an optional attribute which can be used to
              # denote this as an array of languages
              optional :array, :boolean do
                description <<~DESCRIPTION
                  If true, then this field will be an array of languages, and
                  will be backed by a `platformer.language_codes[]` type in PostgreSQL.
                DESCRIPTION
              end

              # Methods
              #
              add_unique_method :default do
                requires :default, :string
              end

              import_shared :allow_null
              import_shared :empty_array_to_null_coercion
              import_shared :unique_field
              import_shared :field_comment
              import_shared :comparison_validators
              import_shared :immutable_validators
              import_shared :remove_null_array_values_coercion
            end
          end
        end
      end
    end
  end
end
