# frozen_string_literal: true

module QuakeLog
  class Main
    @@games = []

    MEANS_OF_DEATH = %w[
      MOD_UNKNOWN MOD_SHOTGUN MOD_GAUNTLET MOD_MACHINEGUN MOD_GRENADE
      MOD_GRENADE_SPLASH MOD_ROCKET MOD_ROCKET_SPLASH MOD_PLASMA MOD_PLASMA_SPLASH
      MOD_RAILGUN MOD_LIGHTNING MOD_BFG MOD_BFG_SPLASH MOD_WATER MOD_SLIME MOD_LAVA
      MOD_CRUSH MOD_TELEFRAG MOD_FALLING MOD_SUICIDE MOD_TARGET_LASER MOD_TRIGGER_HURT
      MOD_NAIL MOD_CHAINGUN MOD_PROXIMITY_MINE MOD_KAMIKAZE MOD_JUICED MOD_GRAPPLE
    ].freeze

    class << self
      def parse_line(line)
        case line
        when /InitGame/
          @@games << {
            players: [],
            kills: []
          }
        when /ClientConnect/
          id = line.match(/ClientConnect: (?<id>\d*)/)['id']
          unless @@games.last[:players].find { |player| player[:id] == id }
            @@games.last[:players] << {
              id: id
            }
          end
        when /ClientUserinfoChanged/
          id, name = line.match(/ClientUserinfoChanged: (\d*) n\\(.*)\\t\\/).captures
          player = @@games.last[:players].find { |player| player[:id] == id }
          player[:name] = name
        when /Kill/
          killer_id, killed_id, mean_id = line.match(/Kill: (\d*) (\d*) (\d*)/).captures
          @@games.last[:kills] << {
            killed_id: killed_id,
            killer_id: killer_id,
            mean_of_death: MEANS_OF_DEATH[mean_id.to_i]
          }
        end
      end

      def calculate_score(game)
        score = {}
        game[:players].each { |player| score[player[:id]] = 0 }

        game[:kills].each do |kill|
          case kill[:killer_id]
          when '1022'
            score[kill[:killed_id]] -= 1
          when kill[:killed_id]
            score[kill[:killed_id]] -= 1
          else
            score[kill[:killer_id]] += 1
          end
        end

        score.transform_keys do |id|
          player = game[:players].find { |player| player[:id] == id }
          player[:name]
        end
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
          'total_kills' => game[:kills].size,
          'players' => game[:players].map { |player| player[:name] },
          'kills' => calculate_score(game)
        }
      end

      def parse_file(filename)
        File.foreach(filename) do |line|
          parse_line(line)
          yield if block_given?
        end
      end

      def total_lines(filename)
        `wc -l < #{filename}`.to_i
      end

      def player_kill_report
        JSON.pretty_generate(@@games.map.with_index { |game, index| { "game_#{index + 1}" => format_kill_data(game) } })
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
