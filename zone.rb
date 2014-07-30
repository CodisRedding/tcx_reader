require 'yaml'

class Zone

    attr_reader :min
    attr_reader :max

    def initialize(min, max)
        @min = min
        @max = max
        @seconds = 0
    end

    def add_seconds(seconds)
        @seconds += seconds
    end

    def total_minutes
        if @seconds > 0
            (@seconds / 60).round
        else
            0
        end
    end

    def percentage(total_mins)
        if self.total_minutes > 0
            ((self.total_minutes.to_f / total_mins.to_f) * 100).round.to_s + '%'
        else
            "0%"
        end
    end
end
