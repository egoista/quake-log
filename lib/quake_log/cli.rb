# frozen_string_literal: true

require_relative 'printer'

module QuakeLog
  class Cli
    include QuakeLog::Printer

    def self.start
      new.init
    end

    def init
      print_greetings
      parse_log
      clear_previous_line
      start_main_loop
    end

    def start_main_loop
      loop do
        choice = prompt.select('Choose an option', choices)
        break if choice == 3

        handle_loop_choice(choice)
        clear_previous_line
      end
    end

    private

    def parse_log
      total = QuakeLog::LogParser.total_lines(file_path)
      start_log_bar(total)
      QuakeLog::LogParser.parse_file(file_path) { advance_log_bar }
    end

    def file_path
      File.join(__dir__, '..', '..', 'data', 'qgames.log')
    end

    def choices
      {
        "Player's kill report" => 0,
        "Player's ranking report" => 1,
        "Weapon's kill report" => 2,
        'Exit' => 3
      }
    end

    def handle_loop_choice(choice)
      case choice
      when 0
        print_report(all_games_report(QuakeLog::Report::PlayerKill))
      when 1
        print_report(all_games_report(QuakeLog::Report::PlayerRanking))
      when 2
        print_report(all_games_report(QuakeLog::Report::WeaponKill))
      end
    end

    def all_games_report(report_klass)
      Entity::Game.all.map{|game| report_klass.build(game) }
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
