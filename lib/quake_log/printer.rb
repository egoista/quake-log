# frozen_string_literal: true

module QuakeLog
  module Printer
    def print_greetings
      puts 'Hi, this program parse the quake log and give you 3 reports'
    end

    def print_parse_log_bar
      filename = 'data/qgames.log'
      total = QuakeLog::Main.total_lines(filename)
      bar = TTY::ProgressBar.new('Parsing Log [:bar]', bar_format: :block, total: total)
      QuakeLog::Main.parse_file(filename) { bar.advance }
    end

    def clear_previous_line
      print cursor.clear_lines(2)
    end

    def print_report(report)
      pager.page(report)
    end

    private

    def pager
      @pager ||= TTY::Pager.new
    end

    def cursor
      @cursor ||= TTY::Cursor
    end
  end
end
