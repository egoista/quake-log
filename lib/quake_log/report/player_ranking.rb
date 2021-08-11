module QuakeLog
  module Report
    class PlayerRanking
      class << self
        def build(game)
          game.calculate_score

          {
            game.name => format_ranking_data(game)
          }
        end

        private

        def format_ranking_data(game)
          next_position = 1
          game.players.
            sort_by { |player| player.score }.
            group_by { |player| player.score }.
            map do |_score, players|
              names = players.map(&:name)
              hash_position = { next_position => names }
              next_position += names.size
              hash_position
            end
        end
      end
    end
  end
end