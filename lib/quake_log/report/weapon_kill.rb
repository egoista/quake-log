module QuakeLog
  module Report
    class WeaponKill
      class << self
        def build(game)
          {
            game.name => {
              'kills_by_means' => format_kills_by_death_cause(game)
            }
          }
        end

        private

        def format_kills_by_death_cause(game)
          game.kills
            .group_by { |kill| kill.mean_of_death }
            .transform_values(&:size)
        end

        def format_score(game)
          game.players.map { |player| { player.name => player.score } }
        end
      end
    end
  end
end