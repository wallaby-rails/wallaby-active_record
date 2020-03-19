# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    # Pundit provider for ActiveRecord
    class PunditProvider < PunditAuthorizationProvider
      # Filter a scope
      # @param _action [Symbol, String]
      # @param scope [Object]
      # @return [Object]
      def accessible_for(_action, scope)
        Pundit.policy_scope! user, scope
      rescue Pundit::NotDefinedError
        Rails.logger.warn "Cannot find scope policy for #{scope.inspect}.\nfrom #{__FILE__}:#{__LINE__}"
        scope
      end
    end
  end
end
