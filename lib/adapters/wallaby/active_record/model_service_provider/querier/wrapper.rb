# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      class Querier
        # Build up query using the results
        class Wrapper
          attr_reader :list
          delegate :push, :each, to: :list

          def initialize(list = [])
            @list = list
          end

          def [](key)
            list.last[key]
          end
        end
      end
    end
  end
end
