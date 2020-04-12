# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # Query builder
      class Querier
        TEXT_FIELDS = %w(string text citext longtext tinytext mediumtext).freeze

        # @param model_decorator [Wallaby::ModelDecorator]
        def initialize(model_decorator)
          @model_decorator = model_decorator
          @model_class = @model_decorator.model_class
        end

        # Extract the filter and query information
        # from parameters `filter` and `q` respectively,
        # and execute query based on the information.
        # @param params [ActionController::Parameters]
        # @return [ActiveRecord::Relation]
        def search(params)
          filter_name, keywords, field_queries = extract params
          scope = filtered_by filter_name
          query = text_search keywords
          query = field_search field_queries, query
          scope.where query
        end

        protected

        # @return [Arel::Table] arel table
        def table
          @model_class.arel_table
        end

        # @param params [ActionController::Parameters]
        # @return [Array<String, Array, Array>] filter_name, keywords, field_queries
        def extract(params)
          expressions = Transformer.execute params[:q]
          keywords = expressions.select { |v| v.is_a? String }
          field_queries = expressions.select { |v| v.is_a? Wrapper }
          filter_name = params[:filter]
          [filter_name, keywords, field_queries]
        end

        # Use the filter name to find out the scope in the following precedents:
        # - scope from metadata
        # - defined scope from the model
        # - unscoped
        # @param filter_name [String] filter name
        # @return [ActiveRecord::Relation]
        def filtered_by(filter_name)
          valid_filter_name =
            FilterUtils.filter_name_by(filter_name, @model_decorator.filters)
          scope = find_scope(valid_filter_name)
          if scope.blank? then unscoped
          elsif scope.is_a?(Proc) then @model_class.instance_exec(&scope)
          elsif @model_class.respond_to?(scope)
            @model_class.public_send(scope)
          else unscoped
          end
        end

        # Find out the scope for given filter
        # - from filter metadata
        # - filter name itself
        # @param filter_name [String] filter name
        # @return [String]
        def find_scope(filter_name)
          @model_decorator.filters[filter_name].try(:[], :scope) || filter_name
        end

        # @return [ActiveRecord::Relation] Unscoped query
        def unscoped
          @model_class.where nil
        end

        # Search text for the text columns (see {}) in `index_field_names`
        # @param keywords [String] keywords
        # @param query [ActiveRecord::Relation, nil]
        # @return [ActiveRecord::Relation, nil]
        def text_search(keywords, query = nil)
          return query unless keywords_check? keywords

          text_fields.each do |field_name|
            sub_query = nil
            keywords.each do |keyword|
              exp = table[field_name].matches(Escaper.execute(keyword))
              sub_query = sub_query.try(:and, exp) || exp
            end
            query = query.try(:or, sub_query) || sub_query
          end
          query
        end

        # Perform SQL query for the colon query (e.g. data:<2000-01-01)
        # @param field_queries [Array]
        # @param query [ActiveRecord::Relation]
        # @return [ActiveRecord::Relation]
        def field_search(field_queries, query)
          return query unless field_check? field_queries

          field_queries.each do |exps|
            sub_queries = build_sub_queries_with exps
            query = query.try(:and, sub_queries) || sub_queries
          end
          query
        end

        # @return [Array<String>] a list of text fields from `index_field_names`
        def text_fields
          @text_fields ||= begin
            index_field_names = @model_decorator.index_field_names.map(&:to_s)
            @model_decorator.fields.select do |field_name, metadata|
              index_field_names.include?(field_name) &&
                TEXT_FIELDS.include?(metadata[:type].to_s)
            end.keys
          end
        end

        # @param keywords [Array<String>] a list of keywords
        # @return [false] when keywords are empty
        # @return [true] when text fields for query exist
        # @raise [Wallaby::UnprocessableEntity] if no text columns can be used for text search
        def keywords_check?(keywords)
          return false if keywords.blank?
          return true if text_fields.present?

          raise UnprocessableEntity, 'Unable to perform keyword search when no text fields can be used for this.'
        end

        # @param field_queries [Array]
        # @return [false] when field queries are blank
        # @return [true] when field queries are blank
        # @raise [Wallaby::UnprocessableEntity] if invalid fields are entered
        def field_check?(field_queries)
          return false if field_queries.blank?

          fields = field_queries.map { |exp| exp[:left] }
          invalid_fields = fields - @model_decorator.fields.keys
          return true if invalid_fields.blank?

          raise UnprocessableEntity, "Unable to perform field colon search for #{invalid_fields.to_sentence}"
        end

        # @param exps [Wallaby::ActiveRecord::ModelServiceProvider::Querier::Wrapper]
        # @return [ActiveRecord::Relation] sub queries connected using OR
        def build_sub_queries_with(exps)
          query = nil
          exps.each do |exp|
            sub = table[exp[:left]].try(exp[:op], exp[:right])
            query = query.try(exp[:join], sub) || sub
          end
          query
        end
      end
    end
  end
end
