class GarminConnector

    def initialize
        @garmin_config = YAML.load_file('garmin_connector_config.yml')
    end

    def garmin_connected?
        File.exists?(@garmin_config[:garmin_device])
    end

    def convert_fit_to_tcx
        if self.garmin_connected?
            puts @garmin_config[:activities_path_fit_pattern]
            Dir.glob(@garmin_config[:activities_path_fit_pattern]) do |f|
                name = File.basename(f, File.extname(f)) + '.tcx'
                tcx = "#{Dir.pwd}/tcx/#{name}"
                puts tcx
                if !File.exists?(tcx)
                    fork { exec("python fittotcx.py #{f} > #{tcx}") }
                    Process.wait
                end
            end
        end
    end
end
