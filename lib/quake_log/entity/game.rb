# frozen_string_literal: true

module QuakeLog
  module Entity
    class Game
      attr_accessor :players, :kills, :name

      @@games = []

      def self.all
        @@games
      end

      def self.clear_games
        @@games = []
      end

      def self.last
        all.last
      end

      def initialize
        @players = []
        @kills = []
        @name = "game_#{@@games.size + 1}"
        @@games << self
      end

      def find_player(id)
        return World.instance if id == World.instance.id

        @players.find { |player| player.id == id }
      end

      def create_player(id)
        return World.instance if id == World.instance.id

        new_player = Player.new(id)
        @players << new_player

        new_player
      end

      def create_kill(killer_id, murdered_id, mean_id)
        murdered = find_player(murdered_id)
        killer = find_player(killer_id)
        kill = Kill.new(killer, murdered, mean_id)
        @kills << kill

        kill
      end

      def calculate_score
        reset_score
        analyze_kills
      end

      private

      def reset_score
        @players.each { |player| player.score = 0 }
      end

      def analyze_kills
        @kills.each(&:set_score)
      end
    end
  end
end
