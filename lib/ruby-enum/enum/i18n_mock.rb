# frozen_string_literal: true

# :nocov:
module Ruby
  module Enum
    ##
    # Mock I18n module in case the i18n gem is not available.
    module I18nMock
      def self.load_path
        []
      end

      def self.translate(key, _options = {})
        key
      end
    end
  end
end
# :nocov:
