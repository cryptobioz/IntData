def shazam_artists(path)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.shazam.Shazam/Documents/ShazamDataModel.sqlite"
    db.results_as_hash = true
    stm = db.execute "SELECT ZNAME FROM ZSHARTISTMO"
    table_shazam_artists = Terminal::Table.new :headings => ['Artists'], :rows => stm
    puts table_shazam_artists

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end
