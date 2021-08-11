# frozen_string_literal: true

module QuakeLog
  class Main
    class << self
      def calculate_score(game)
        game.calculate_score

        game.players.map { |player| { player.name => player.score } }
      end

      def calculate_ranking(game)
        score = calculate_score(game)
        next_position = 1
        score
          .sort_by { |_key, value| -value }
          .group_by { |_name, score| score }
          .map do |_score, array|
          names = array.map { |name, _score| name }
          hash_position = { next_position => names }
          next_position += names.size
          hash_position
        end
      end

      def calculate_kills_by_death_cause(game)
        game[:kills]
          .group_by { |kill_hash| kill_hash[:mean_of_death] }
          .transform_values(&:size)
      end

      def format_kill_data(game)
        {
          'total_kills' => game.kills.size,
          'players' => game.players.map(&:name),
          'kills' => calculate_score(game)
        }
      end

      def player_kill_report
        JSON.pretty_generate(Entity::Game.all.map.with_index do |game, index|
                               { "game_#{index + 1}" => format_kill_data(game) }
                             end)
      end

      def player_ranking_report
        JSON.pretty_generate(@@games.map.with_index do |game, index|
                               { "game_#{index + 1}" => calculate_ranking(game) }
                             end)
      end

      def weapon_kill_report
        JSON.pretty_generate(@@games.map.with_index do |game, index|
                               { "game_#{index + 1}" => { 'kills_by_means' => calculate_kills_by_death_cause(game) } }
                             end)
      end
    end
  end
end
