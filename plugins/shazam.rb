def shazam_artists(path, export)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.shazam.Shazam/Documents/ShazamDataModel.sqlite"
    db.results_as_hash = true
    stm = db.execute "SELECT ZNAME FROM ZSHARTISTMO"
    if(export == 1)
      Prawn::Document.generate("Exports/Shazam/Artists.pdf") do |pdf|
        pdf.text "Artists\n\n\n", :size => 25
        rows = [["Artists"]]
        stm.each do |row|
          rows << ["#{row[0]}"]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] Artists from Shazam app export done\e[0m"
    else
      table_shazam_artists = Terminal::Table.new :headings => ['Artists'], :rows => stm
      puts table_shazam_artists
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to Shazam database.\e[0m"
  ensure
    db.close if db
  end
end
