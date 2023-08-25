# frozen_string_literal: true

module Platformer
  module Composers
    module ActiveRecord
      module Coercions
        module Common
          class ZeroToNull < Parsers::AllModels::ForFields
            # install all the zero_to_null coercions for each model
            for_numeric_fields do |name:, model:, array:, allow_null:|
              for_method :zero_to_null do
                description <<~DESCRIPTION
                  Create a before_validation callback on this active_record class which
                  will convert #{array ? "all values of 0" : "the value 0"} in the `#{name}`
                  field into null. This logic is also injected into ActiveRecord
                  and overrides the write_attribute method, this will ensure that the coercion
                  happens even if callbacks are skipped.
                DESCRIPTION

                # add the before_validation callback to the active record class
                if array
                  model.before_validation do
                    value = send(name)
                    if value.is_a?(Array)
                      send "#{name}=", value.map { |v| (v == 0) ? nil : v }
                    end
                  end
                else
                  model.before_validation do
                    value = send(name)
                    if value == 0
                      send "#{name}=", nil
                    end
                  end
                end

                # inject this into the class and override the write_attribute system
                model.attr_zero_to_null_coercion name
              end
            end
          end
        end
      end
    end
  end
end