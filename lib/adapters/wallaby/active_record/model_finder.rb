# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    # Finder to return all the ActiveRecord models that are not one of the following types:
    #
    # 1. abstract class
    # 2. anonymous class
    # 3. the HABTM relation class
    class ModelFinder < ::Wallaby::ModelFinder
      # @return [Array<Class>] a list of ActiveRecord subclasses
      def all
        validate_application_record

        ::ActiveRecord::Base.descendants.reject do |model_class|
          abstract?(model_class) || anonymous?(model_class) || habtm?(model_class)
        end.sort_by(&:to_s)
      end

      private

      # Make sure that the ApplicationRecord inherits from ActiveRecord::Base
      # and it's maked as `abstract_class`
      def validate_application_record
        return unless defined?(::ApplicationRecord)
        return unless ::ApplicationRecord < ::ActiveRecord::Base
        return if ::ApplicationRecord.try(:abstract_class)

        raise ArgumentError, <<~INSTRUCTION
          Please ensure to flag ApplicationRecord as abstract class by adding the following line:

            self.abstract_class = true
        INSTRUCTION
      end

      # @param model_class [Class]
      # @return [true] if model class is an abstract class
      # @return [false] otherwise
      def abstract?(model_class)
        model_class.abstract_class?
      end

      # @see Wallaby::ModuleUtils.anonymous_class?
      def anonymous?(model_class)
        ModuleUtils.anonymous_class? model_class
      end

      # Check and see if given model class is intermediate class that generated
      # for has and belongs to many assocation
      # @param model_class [Class]
      # @return [true] if model class is a HABTM relation class
      #   that connects two ActiveRecord models
      # @return [false] otherwise
      def habtm?(model_class)
        model_class.name.index('HABTM')
      end
    end
  end
end
