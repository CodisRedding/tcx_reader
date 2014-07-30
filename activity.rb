require 'rexml/document'
require 'time'
require_relative 'track_point'
require_relative 'zone'
require_relative 'watts'

class Activity

    attr_reader :start_time
    attr_reader :zones
    attr_reader :total_minutes
    attr_reader :total_seconds
    attr_reader :watts

    def initialize(tcx_file)
        @zones_config = YAML.load_file('zone_config.yml')
        @xml = REXML::Document.new(File.open(tcx_file))
        @start_time = Time.iso8601(@xml.elements["//Activity[@Sport='Biking']"].elements["Id"].text)
        @track_points = []
        @zones = []
        @watts = []
        @total_minutes = 0
        @total_seconds = 0
        @xml.elements.each("//Trackpoint") do |tp|
            if tp.has_elements?
                tm = Time.iso8601(tp.elements["Time"].text)
                hr = -1
                watts = -1

                # Grab heart rate for zones
                if tp.elements["HeartRateBpm/Value"]
                    hr = (tp.elements["HeartRateBpm/Value"].text).to_i
                end

                # Grab watts
                if tp.elements["Extensions/TPX/Watts"]
                    watts = (tp.elements["Extensions/TPX/Watts"].text).to_i
                end

                @track_points << TrackPoint.new(tm, hr, watts)
            end
        end

        fill_total_activity_time
        fill_zones
        fill_watts
    end

    def fill_total_activity_time
        prev_tp_seconds = @start_time.to_f
        @track_points.each do |tp|
            @total_seconds += tp.time.to_f - prev_tp_seconds
            prev_tp_seconds = tp.time.to_f
        end

        @total_minutes = (@total_seconds / 60).round
    end

    def fill_zones
        @zones_config.each do |k,v|
            @zones << Zone.new(@zones_config[k].first, @zones_config[k].last)
        end

        prev_tp_seconds = @start_time.to_f
        @track_points.each do |tp|

            @zones.each do |z|
                if tp.hr.between?(z.min, z.max)
                    seconds = tp.time.to_f - prev_tp_seconds
                    z.add_seconds(seconds)
                end
            end

            prev_tp_seconds = tp.time.to_f
        end
    end

    def fill_watts

        power_dist = Hash.new(0)
        power_secs = Hash.new(0)
        prev_tp_seconds = @start_time.to_f
        highest_watt = 0

        # find highest watt
        @track_points.each do |tp|
            if tp.watts > highest_watt
                highest_watt = tp.watts
            end
        end

        if highest_watt == 0
            return
        end

        # setup hashes
        full_range = Range.new(0, highest_watt)
        full_range.step(25) do |r|
            power_dist["#{r}-#{r + 24}"] = 0
            power_secs["#{r}-#{r + 24}"] = 0
        end

        @track_points.each do |tp|
            full_range.step(25) do |r|
                if tp.watts.between?(r, (r + 24))
                    seconds = tp.time.to_f - prev_tp_seconds
                    power_dist["#{r}-#{r + 24}"] += tp.watts
                    power_secs["#{r}-#{r + 24}"] += seconds
                    break
                end
            end

            prev_tp_seconds = tp.time.to_f
        end

        power_dist.each do |k,v|
            @watts << Watt.new(k, v, power_secs[k])
        end
    end
end
