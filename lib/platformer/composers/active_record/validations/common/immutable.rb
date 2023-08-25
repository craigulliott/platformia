# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Validations
        module Common
          # Install all the immutable validations for each model
          class Immutable < Parsers::AllModels::ForFields
            class IncompatibleImmutableValidationError < StandardError
            end

            for_all_fields except: :phone_number do |name:, model:, array:, allow_null:|
              for_method :immutable do |message:|
                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` can not be changed after the record is created.
                DESCRIPTION

                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:immutable] = true
                args[:message] = message unless message.nil?
                model.validates name, **args
              end

              for_method :immutable_once_set do |message:|
                unless allow_null
                  raise IncompatibleImmutableValidationError, "You can not use `immutable_once_set` on fields which do not allow nil values. Switch this field to allow null values, or use `immutable` instead."
                end

                description <<~DESCRIPTION
                  Create a validation on this active record model which asserts that
                  the value of `#{name}` can not be changed after the value has been set.
                  If a record exists, and the value is null, then it can be set at any
                  time. As soon as the value is updated to a non null value, it is locked
                  and can not be changed.
                DESCRIPTION

                # add the validation to the active record class (using splat for passing the
                # options because `message: nil` is invalid)
                args = {}
                args[:allow_nil] = allow_null
                args[:immutable_once_set] = true
                args[:message] = message unless message.nil?
                model.validates name, **args
              end
            end
          end
        end
      end
    end
  end
end