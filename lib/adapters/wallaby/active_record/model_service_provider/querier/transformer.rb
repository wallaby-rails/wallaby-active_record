# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      class Querier
        # Build up query using the results
        class Transformer < Parslet::Transform
          SIMPLE_OPERATORS = { # :nodoc:
            ':' => :eq,
            ':=' => :eq,
            ':!' => :not_eq,
            ':!=' => :not_eq,
            ':<>' => :not_eq,
            ':~' => :matches,
            ':^' => :matches,
            ':$' => :matches,
            ':!~' => :does_not_match,
            ':!^' => :does_not_match,
            ':!$' => :does_not_match,
            ':>' => :gt,
            ':>=' => :gteq,
            ':<' => :lt,
            ':<=' => :lteq
          }.freeze

          SEQUENCE_OPERATORS = { # :nodoc:
            ':' => :in,
            ':=' => :in,
            ':!' => :not_in,
            ':!=' => :not_in,
            ':<>' => :not_in,
            ':()' => :between,
            ':!()' => :not_between
          }.freeze

          # For single null
          rule null: simple(:value)
          rule null: sequence(:value)

          # For single boolean
          rule(boolean: simple(:value)) { /true/i.match? value }

          # For single string
          rule(string: simple(:value)) { value.try :to_str }

          # For multiple strings
          rule(string: sequence(:value)) { EMPTY_STRING }

          # For operators
          rule left: simple(:left), op: simple(:op), right: simple(:right) do
            oped = op.try :to_str
            operator = SIMPLE_OPERATORS[oped]
            # skip if the operator is unknown
            next unless operator

            lefted = left.try :to_str
            convert =
              case oped
              when ':~', ':!~' then "%#{right}%"
              when ':^', ':!^' then "#{right}%"
              when ':$', ':!$' then "%#{right}"
              end
            Wrapper.new [{ left: lefted, op: operator, right: convert || right }]
          end

          # For operators that have multiple items
          rule left: simple(:left), op: simple(:op), right: sequence(:right) do
            oped = op.try :to_str
            operator = SEQUENCE_OPERATORS[oped]
            next unless operator

            exps = Wrapper.new
            lefted = left.try :to_str
            if right.include? nil
              nil_operator = SIMPLE_OPERATORS[oped]
              next unless nil_operator

              exps.push left: lefted, op: nil_operator, right: right.delete(nil)
            end
            convert = Range.new right.try(:first), right.try(:second) if %w(:() :!()).include?(oped)
            exps.push left: lefted, op: operator, right: convert || right
            exps
          end

          def transform(query_string)
            result = apply Parser.new.parse(query_string || EMPTY_STRING)
            result.is_a?(Array) ? result : [result]
          end
        end
      end
    end
  end
end
