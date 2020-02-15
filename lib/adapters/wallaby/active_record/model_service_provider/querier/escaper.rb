# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      class Querier
        # Build up query using the results
        class Escaper
          include ::ActiveRecord::Sanitization
          LIKE_SIGN = /[%_]/.freeze # :nodoc:
          PCT = '%' # :nodoc:

          class << self
            def execute(keyword)
              first = keyword.first
              last = keyword.last
              start_with, start_index = LIKE_SIGN.match?(first) ? [true, 1] : [false, 0]
              end_with, end_index = LIKE_SIGN.match?(last) ? [true, -2] : [false, -1]
              escaped = sanitize_sql_like keyword[start_index..end_index]
              starting = sign(start_with, first, end_with)
              ending = sign(end_with, last, start_with)

              "#{starting}#{escaped}#{ending}"
            end

            def sign(
              first_condition, first_char, second_condition, default_sign = PCT
            )
              return first_char if first_condition
              return if second_condition

              default_sign
            end
          end
        end
      end
    end
  end
end
