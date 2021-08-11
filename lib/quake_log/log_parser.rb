# frozen_string_literal: true

module QuakeLog
  class LogParser
    class << self
      def parse_file(file_path)
        File.foreach(file_path) do |line|
          parse_line(line)
          yield if block_given?
        end
      end

      def parse_line(line)
        case line
        when /#{line_start}InitGame:/
          build_game
        when /#{line_start}ClientConnect:/
          create_player(line)
        when /#{line_start}ClientUserinfoChanged:/
          update_player_name(line)
        when /#{line_start}Kill:/
          create_kill(line)
        end
      end

      def total_lines(file_path)
        `wc -l < #{file_path}`.to_i
      end

      private

      def line_start
        '^\s*\d\d?:\d\d\s'
      end

      def build_game
        Entity::Game.new
      end

      def update_player_name(line)
        id, name = line.match(/ClientUserinfoChanged: (\d*) n\\(.*)\\t\\/).captures
        player = Entity::Game.last.find_player(id)
        player.name = name
      end

      def create_player(line)
        id = line.match(/ClientConnect: (?<id>\d*)/)['id']
        Entity::Game.last.create_player(id) unless Entity::Game.last.find_player(id)
      end

      def create_kill(line)
        killer_id, killed_id, mean_id = line.match(/Kill: (\d*) (\d*) (\d*)/).captures
        Entity::Game.last.create_kill(killer_id, killed_id, mean_id)
      end
    end
  end
end
