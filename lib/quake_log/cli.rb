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
      print_parse_log_bar
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
        print_report(QuakeLog::Main.player_kill_report)
      when 1
        print_report(QuakeLog::Main.player_ranking_report)
      when 2
        print_report(QuakeLog::Main.weapon_kill_report)
      end
    end

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
