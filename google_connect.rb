require 'rubygems'
require 'google_drive'

class GoogleConnect

    def initialize(username, passw)
        @session = GoogleDrive.login(username, passw)
    end

    def get_list_of_remote_files
        for file in @session.files
            p file.title
        end
    end

    def get_spreadsheet(title)
        @session.spreadsheet_by_title(title)
    end

    def create_spreadsheet(title, default_title = Time.now.year.to_s)
        if self.get_spreadsheet(title)
            puts "spreadsheet #{title} exists already"
        else
            puts "creating spreadsheet #{title}"
            @session.create_spreadsheet(title)
            spreadsheet = self.get_spreadsheet(title)
            ws = spreadsheet.worksheets[0]
            ws.title = default_title
            ws.save()
        end
    end
end
