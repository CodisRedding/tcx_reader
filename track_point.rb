class TrackPoint

    attr_reader :time
    attr_reader :hr
    attr_reader :watts

    def initialize(time, hr, watts)
        @time = time
        @hr = hr
        @watts = watts
    end
end
