# frozen_string_literal: true

module QuakeLog
  module Entity
    class Player
      attr_accessor :id, :name, :score

      def initialize(id)
        @id = id
        @score = 0
      end

      def increase_score
        @score += 1
      end

      def decrease_score
        @score -= 1
      end
    end
  end
end
