# frozen_string_literal: true

module QuakeLog
  module Printer
    def print_greetings
      puts 'Hi, this program parse the quake log and give you 3 reports'
    end

    def start_log_bar(total)
      @bar = TTY::ProgressBar.new('Parsing Log [:bar]', bar_format: :block, total: total)
    end

    def advance_log_bar
      @bar.advance
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
