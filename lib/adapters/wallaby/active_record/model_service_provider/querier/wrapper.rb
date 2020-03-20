# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      class Querier
        # Wrapper for the transform result
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
