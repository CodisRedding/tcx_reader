require 'yaml'

class Watt

    attr_reader :range
    attr_reader :watts
    attr_reader :seconds

    def initialize(range, watts, seconds)
        @range = range
        @watts = watts
        @seconds = seconds
    end

    def total_minutes
        if @seconds > 0
            (@seconds / 60).round(2)
        else
            0
        end
    end

    def total_time
        if @seconds < 60
            "#{Time.at(@seconds).gmtime.strftime('%-s')}s"
        elsif @seconds.between?(60, 3600)
            Time.at(@seconds).gmtime.strftime('%-M:%S')
        else
            Time.at(@seconds).gmtime.strftime('%l:%M:%S')
        end
    end

    def percentage(total_mins)
        ((self.total_minutes.to_f / total_mins.to_f) * 100).round(1)
    end
end
