############
# FAVORITES
def mumble_favorites(path, export)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/info.mumble.Mumble/Library/mumble.sqlite"
    db.results_as_hash = true
    stm = db.execute "SELECT name, hostname, port, username, password FROM favourites"
    if(export == 1)
      Prawn::Document.generate("Exports/Mumble/Favorites_servers.pdf", :page_layout => :landscape) do |pdf|
        pdf.text "Favorites servers\n\n\n", :size => 25
        rows = [["Name", "Hostname", "Port", "Username", "Password"]]
        stm.each do |row|
          rows << ["#{row['name']}","#{row['hostname']}", "#{row['port']}", "#{row['username']}", "#{row['password']}"]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] Mumble favorites servers export done\e[0m"
    else
      rows = []
      stm.each do |row|
        rows << ["#{row['name']}", "#{row['hostname']}", "#{row['port']}", "#{row['username']}", "#{row['password']}"]
      end
      table_mumble_favorites = Terminal::Table.new :headings => ['Name', 'Hostname', 'Port', 'Username', 'Password'], :rows => rows
      puts table_mumble_favorites
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to Mumble database.\e[0m"
  ensure
    db.close if db
  end
end
