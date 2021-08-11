# frozen_string_literal: true

module QuakeLog
  module Entity
    class World
      @instance = new

      private_class_method :new

      class << self
        attr_reader :instance
      end

      def id
        '1022'
      end
    end
  end
end
