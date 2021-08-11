module QuakeLog
  module Report
    class PlayerKill
      class << self
        def build(game)
          game.calculate_score

          {
            game.name => format_kill_data(game)
          }
        end

        private

        def format_kill_data(game)
          {
            'total_kills' => game.kills.size,
            'players' => game.players.map(&:name),
            'kills' => format_score(game)
          }
        end

        def format_score(game)
          game.players.map { |player| { player.name => player.score } }
        end
      end
    end
  end
end