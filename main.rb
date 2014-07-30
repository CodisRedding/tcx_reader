require 'fileutils'
require_relative 'activity'
require_relative 'garmin_connector'
require_relative 'live_spreadsheet'

# Check for Garmin device
#connector = GarminConnector.new
#if !connector.garmin_connected?
#    puts "No Garmin device found."
#    exit
#end
# Pull directly from garmin 500 activites
puts "Converting .fit files to .tcx..."
#connector.convert_fit_to_tcx
puts "Completed conversions"

spreadsheet = LiveSpreadsheet.new("Test Schedule")
spreadsheet.ensure_headers

return

Dir.glob("tcx/*.tcx") do |f|
    activity = Activity.new(f)

    watts_len = 0
    activity.watts.each { |w| watts_len += w.seconds }
    #puts "Watts Length: #{watts_len}"
    #puts "#{activity.total_seconds} - #{watts_len} = #{activity.total_seconds - watts_len}"
    missing_data = activity.total_seconds - watts_len

    puts "Activity Length: #{Time.at(activity.total_seconds).gmtime.strftime('%l:%M:%S')}"
    puts "Unaccoutanted for minutes due to missing watts data: #{Time.at(missing_data).gmtime.strftime('%M:%S')}"

    if activity.zones
        puts "\nRide: #{activity.start_time}\n"

        zone = 0
        activity.zones.each do |z|

            zone += 1
            puts "Zone#{zone}\t Time in Zone: #{z.total_minutes}\t Percentage: #{z.percentage(activity.total_minutes)}"
        end
    end

    if activity.watts
        activity.watts.each do |w|
            print "#{w.range} W ".rjust(12) + "\t"
            print "Time Spent: " + "#{w.total_time}".ljust(9) + " (#{w.percentage(activity.total_minutes)}%)".ljust(9) + '|'
            if w.percentage(activity.total_minutes) > 0.1 then print '-' end
            w.percentage(activity.total_minutes).round.times { print '-' }
            puts '|'
            #puts " seconds #{w.seconds}"
        end
    end

    # Remove tcx file.
    #FileUtils.rm(f)
end
