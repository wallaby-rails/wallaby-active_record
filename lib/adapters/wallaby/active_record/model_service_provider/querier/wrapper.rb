# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      class Querier
        # Wrapper for the transform result
        class Wrapper
          attr_reader :list
          delegate :push, to: :list
          delegate :each, to: :list
          delegate :last, to: :list
          delegate :[], to: :last

          def initialize(list = [])
            @list = list
          end
        end
      end
    end
  end
end
