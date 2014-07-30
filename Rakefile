require 'yaml'

desc "Builds initial yaml config file for custom zones."
task :build_zones_config do
    zones = { 
        z1: 0..137, 
        z2: 138..151, 
        z3: 152..157, 
        z4: 158..168, 
        z5: 169..500 
    }
    File.open("zone_config.yml", "w") { |f| YAML.dump(zones, f) }
end

desc "Builds initial yaml config file for the Garmin device."
task :build_garmin_config do
    # linux only
    garmin_activities_path = { 
        activities_path_fit_pattern: '/media/GARMIN/Garmin/Activities/*.fit',
        garmin_device: '/media/GARMIN'
    }

    File.open("garmin_connector_config.yml", "w") { |f| YAML.dump(garmin_activities_path, f) }
end
