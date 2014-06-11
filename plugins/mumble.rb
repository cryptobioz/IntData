############
# FAVORITES
def mumble_favorites(path)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/info.mumble.Mumble/Library/mumble.sqlite"
    db.results_as_hash = true
    stm = db.execute "SELECT name, hostname, port, username, password FROM favourites"
    rows = []
    stm.each do |row|
      rows << ["#{row['name']}", "#{row['hostname']}", "#{row['port']}", "#{row['username']}", "#{row['password']}"]
    end
    table_mumble_favorites = Terminal::Table.new :headings => ['Name', 'Hostname', 'Port', 'Username', 'Password'], :rows => rows
    puts table_mumble_favorites

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end
