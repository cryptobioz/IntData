def mango_servers(path)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/sk.mediaware.mangolite/Documents/mango.db"
    db.results_as_hash = true
    stm = db.execute "SELECT host, port, nick, user, real, channels FROM servers"
    rows = []
    stm.each do |row|
      rows << ["#{row['host']}", "#{row['port']}", "#{row['nick']}", "#{row['user']}", "#{row['real']}", "#{row['channels']}"]
    end
    table_mango_servers = Terminal::Table.new :headings => ['Host', 'Port', 'Nick', 'User', 'Real', 'Channels'], :rows => rows
    puts table_mango_servers

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end


