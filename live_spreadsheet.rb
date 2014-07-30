require_relative 'google_connect'

class LiveSpreadsheet

    def initialize(title, default_title = Time.now.year.to_s)
        @drive = GoogleConnect.new('rocky.4q@gmail.com', 'Question00p')
        @drive.create_spreadsheet(title)
        spreadsheet = @drive.get_spreadsheet(title)
        spreadsheet.worksheets.each { |w| if w.title == default_title then @worksheet = w end }
    end

    def ensure_headers
        headers = ['', 'Total Duration', 'Workload', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

        headers_updated = false
        puts "ensuring headers..."
        for col in 1..10
            if headers[col - 1] != @worksheet[2, col]
                puts "#{headers[col - 1]} != #{@worksheet[2, col]} updating..."
                headers_updated = true
                @worksheet[2, col] = headers[col -1]
            end
        end

        zone_col = headers.length
        zone_cnt = 0
        zones_config = YAML.load_file('zone_config.yml')
        zones_config.each do |k,v|
            zone_cnt += 1
            zone_col += 1 
            zone_header = "Z#{zone_cnt} (#{zones_config[k].first}-#{zones_config[k].last})"

            if @worksheet[2, zone_col] != zone_header
                puts "#{@worksheet[2, zone_col]} != #{zone_header} updating..."
                headers_updated = true
                @worksheet[2, zone_col] = zone_header
            end
        end

        if headers_updated 
            puts "updating header changes on google..."
            @worksheet.save()
            puts "updated"
        else
            puts "headers ok"
        end
    end

    def ensure_dates

        

        weeks = {}
        found_monday = false
        Date.new(Time.now.year, 1, 1).upto(Date.new(Time.now.year, 12, 31)) do |day|
            if !found_monday && day.monday?
                found_monday = true
            end

            if day.monday?
                week = day.upto(day)
            end 
        end
    end
end
