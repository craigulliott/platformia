module Platformer
  module DSLs
    module SharedDSLConfiguration
      module Models
        module Fields
          module Validators
            module TextValidators
              # immutable validators which are shared between all fields
              DSLCompose::SharedConfiguration.add :string_validators do
                add_method :validate_minimum_length do
                  description <<~DESCRIPTION
                    Ensures that the string length of the value of this field
                    is at least as long as the provided number of characters.
                    This will create an active record validation, a database
                    constraint and will be used in API validation and generated
                    documentation.
                  DESCRIPTION

                  requires :value, :integer do
                    description <<~DESCRIPTION
                      The value to validate against. The provided value must have
                      a number of characters greater than or equal to this value
                    DESCRIPTION
                  end

                  # add `deferrable: boolean` and `initially_deferred: boolean` options
                  import_shared :deferrable_constraint

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be raised if the validation fails.
                    DESCRIPTION
                  end

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a comment to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_maximum_length do
                  description <<~DESCRIPTION
                    Ensures that the string length of the value of this field
                    is not longer than the provided number of characters. This
                    will create an active record validation, a database
                    constraint and will be used in API validation and generated
                    documentation.
                  DESCRIPTION

                  requires :value, :integer do
                    description <<~DESCRIPTION
                      The value to validate against. The provided value must have
                      a number of characters less than or equal to this value
                    DESCRIPTION
                  end

                  # add `deferrable: boolean` and `initially_deferred: boolean` options
                  import_shared :deferrable_constraint

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be raised if the validation fails.
                    DESCRIPTION
                  end

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a comment to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_length_is do
                  description <<~DESCRIPTION
                    Ensures that the string length of the value of this field
                    is exactly as long as the provided number of characters. This
                    will create an active record validation, a database
                    constraint and will be used in API validation and generated
                    documentation.
                  DESCRIPTION

                  requires :value, :integer do
                    description <<~DESCRIPTION
                      The value to validate against. The provided value must have
                      a number of characters equal to this value
                    DESCRIPTION
                  end

                  # add `deferrable: boolean` and `initially_deferred: boolean` options
                  import_shared :deferrable_constraint

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be raised if the validation fails.
                    DESCRIPTION
                  end

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a comment to the database constraint.
                    DESCRIPTION
                  end
                end

                add_method :validate_format do
                  description <<~DESCRIPTION
                    Ensures that the value of this field matches the provided regex.
                    This will create an active record validation, a database
                    constraint and will be used in API validation and generated
                    documentation.
                  DESCRIPTION

                  requires :value, :object do
                    validate_is_a Regexp
                    description <<~DESCRIPTION
                      The regex to compare the value against. The provided value
                      must match successfully against this regex.
                    DESCRIPTION
                  end

                  # add `deferrable: boolean` and `initially_deferred: boolean` options
                  import_shared :deferrable_constraint

                  optional :message, :string do
                    description <<~DESCRIPTION
                      The message which will be raised if the validation fails.
                    DESCRIPTION
                  end

                  optional :comment, :string do
                    description <<~DESCRIPTION
                      A comment which explains the reason for this validation
                      on this field. This will be used to generate documentation,
                      and will be added as a comment to the database constraint.
                    DESCRIPTION
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end