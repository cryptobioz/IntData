#######
# CALLS
def skype_calls(path, pseudo)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/#{pseudo}/main.db"
    db.results_as_hash = true
    stm = db.execute "SELECT identity, dispname, languages, call_duration  FROM CallMembers"
    rows = []
    stm.each do |row|
      rows << ["#{row['identity']}", "#{row['dispname']}", "#{row['languages']}", "#{row['call_duration']}"]
    end
    table_skype_calls = Terminal::Table.new :headings => ['Pseudo', 'Name', 'Languages', 'Call Duration'], :rows => rows
    puts table_skype_calls

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end

##########
# MESSAGES
def skype_messages(path, pseudo)
  begin
  	db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/#{pseudo}/main.db"
    db.results_as_hash = true
    stm = db.execute "SELECT author, from_dispname, body_xml FROM Messages"
    stm.each do |row|
      puts "#{row['author']} (#{row['from_dispname']}) ==> #{row['body_xml']}\n\n"
    end

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end


##########
# CONTACTS
def skype_contacts(path, pseudo)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/#{pseudo}/main.db"
    db.results_as_hash = true
    stm = db.execute "SELECT skypename, fullname, country, province, city, emails, about FROM Contacts"
    rows = []
    stm.each do |row|
      rows << ["#{row['skypename']}", "#{row['fullname']}", "#{row['country']}", "#{row['province']}", "#{row['city']}", "#{row['emails']}", "#{row['about']}"]
    end
    table_skype_contacts = Terminal::Table.new :headings => ['Skype name', 'Name', 'Country', 'Province', 'City', 'Emails', 'About'], :rows => rows
    puts table_skype_contacts

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end
