# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    # move this to wallaby-core later
    class Logger
      class << self
        %w(debug warn info).each do |method_id|
          define_method method_id do |message, replacements = {}|
            source = caller(replacements.delete(:source) || 1, 1).first
            Rails.logger.public_send(
              method_id,
              "#{method_id.upcase}: #{format message, replacements}\nfrom #{source}"
            )
            nil
          end
        end
      end
    end
  end
end
