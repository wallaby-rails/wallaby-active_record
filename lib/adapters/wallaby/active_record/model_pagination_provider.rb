# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    # Model pagination provider for {Wallaby::ActiveRecord}
    class ModelPaginationProvider < ::Wallaby::ModelPaginationProvider
      # Check if collection can be paginated
      # @return [true] if paginatable
      # @return [false] if not paginatable
      def paginatable?
        paginatable = @collection.respond_to?(:unscope) && @collection.respond_to?(:count)
        Logger.warn "#{@collection} is not paginatable." unless paginatable

        paginatable
      end

      # @return [Integer] total count for the collection
      def total
        @collection.try(:unscope, :offset, :limit).try(:count)
      end

      # @return [Integer] page size from parameters or
      #   {https://rubydoc.info/gems/wallaby-core/Wallaby/Configuration/Pagination#page_size-instance_method page_size}
      #   Wallaby configuration
      def page_size
        (@params[:per] || Wallaby.configuration.pagination.page_size).to_i
      end

      # @return [Integer] page number from parameters starting from 1
      def page_number
        [@params[:page].to_i, 1].max
      end
    end
  end
end
