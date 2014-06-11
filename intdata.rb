#!/usr/bin/ruby

require 'sqlite3'
require 'terminal-table'
require 'plist'
###########
# ALL CALLS
def all_calls(path)
  # Phone numbers
  begin
    db = SQLite3::Database.new path+"wireless/Library/CallHistory/call_history.db"
    db.results_as_hash = true
    stm = db.execute "SELECT address, date FROM call"
    rows = []
    stm.each do |row|
      rows << ["#{row['address']}", Time.at(row['date'])]
    end
    table_calls = Terminal::Table.new :headings => ["To", "Date"], :rows => rows
    puts table_calls

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end

  # How many calls ?
  begin
    db = SQLite3::Database.new path+"wireless/Library/CallHistory/call_history.db"
    stm = db.prepare "SELECT seq FROM sqlite_sequence WHERE name = 'call'"
    rs = stm.execute
    rs.each do |row|
      puts "Number of calls : "+row.join+"\s"
    end

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    stm.close if stm
    db.close if db
  end
end


##############
# ALL ACCOUNTS
def all_accounts(path)
  begin
    db = SQLite3::Database.new path+"mobile/Library/Accounts/Accounts3.sqlite"
    stm = db.execute "SELECT ZACCOUNTDESCRIPTION, ZUSERNAME FROM ZACCOUNT"
    table = Terminal::Table.new :headings => ['Description', 'User'], :rows => stm
    puts table

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end

#############
# ADRESS BOOK
def all_address_book(path)
  begin
    db = SQLite3::Database.new path+"mobile/Library/AddressBook/AddressBook.sqlitedb"
    stm = db.execute "SELECT ABPerson.First, ABPerson.Last, ABMultiValue.value, ABPerson.Organization, ABPerson.Department, ABPerson.Birthday, ABPerson.JobTitle FROM ABPerson, ABMultiValue WHERE ABPerson.ROWID = ABMultiValue.record_id"
    table_address_book = Terminal::Table.new :headings => ['First', 'Last', 'Contact', 'Organization', 'Department', 'Birthday', 'JobTitle'], :rows => stm
    puts table_address_book

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end

##########
# PICTURES
def all_pictures(path)
    system("open "+path+"mobile/Media/DCIM/100APPLE/ &")
end



#############
# META DATA MAILS
def all_md_mails(path)
  begin
    db = SQLite3::Database.new path+"mobile/Library/Mail/Recents"
    db.results_as_hash = true
    stm = db.execute "SELECT display_name, address, sending_address, last_date FROM recents"
    rows = []
    stm.each do |row|
      rows << ["#{row['display_name']}", "#{row['address']}", "#{row['sending_address']}", Time.at(row['last_date']/10)]
    end
    table_md_mails = Terminal::Table.new :headings => ['Receiver', 'Address of Receiver', 'Address of sender', 'Date'], :rows => rows
    puts table_md_mails

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end



######
# SMS
def all_sms(path)
  begin
    db = SQLite3::Database.new path+"mobile/Library/SMS/sms.db"
    db.results_as_hash = true
    stm = db.execute "SELECT text, service, account, date FROM message"
    rows = []
    stm.each do |row|
      rows << ["#{row['account']}", "#{row['service']}", "#{row['text']}", Time.at(row['date'])]
    end
    table_sms = Terminal::Table.new :headings => ['Account', 'Service', 'Text', 'Date'], :rows => rows
    puts table_sms

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end

#######
# NOTES
def all_notes(path)
  begin
    db = SQLite3::Database.new path+"mobile/Library/Notes/notes.sqlite"
    db.results_as_hash = true
    stm = db.execute "SELECT ZCONTENT FROM ZNOTEBODY"
    stm.each do |row|
      puts "\n\n\n"
      puts row
    end
  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end


###########
# RECORDING
def all_recordings(path)
    system("open "+path+"mobile/Media/Recordings/")
end

####################
# SAFARI - BOOKMARKS
def all_safari_bookmarks(path)
  begin
    db = SQLite3::Database.new path+"mobile/Library/Safari/Bookmarks.db"
    stm = db.execute "SELECT title, url FROM bookmarks"
    table_safari_bookmarks = Terminal::Table.new :headings => ['Title', 'URL'], :rows => stm
    puts table_safari_bookmarks

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end
end


##################
# SAFARI - HISTORY
def all_safari_history(path)
  file_safari_history = File.open(path+"mobile/Library/Safari/SuspendState.plist", "r")
  file_safari_history.each_line{ |line|
    url = /<string>http(.*)</.match(line)
    puts url
  }

end

###################################
############## SKYPE ##############
###################################

#######
# CALLS
def skype_calls(path)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/snowplock/main.db"
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
def skype_messages(path)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/snowplock/main.db"
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
def skype_contacts(path)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/snowplock/main.db"
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


####################################
############## SHAZAM ##############
####################################


#########
# ARTISTS
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





################################
#
##################################

#######
#



########
# MAIN #
########

# Variables

# Using libimobiledevice for create a backup of the device
if(ARGV[0] == "backup")
  if(ARGV[1] == "-f")
    if(ARGV[2])
      folder = ARGV[2]
    else
      puts "You have to specify the destination folder with -f FOLDER"
      exit(1)
    end
  else
    puts "You have to specify the destination folder with -f FOLDER"
    exit(1)
  end
  system("mkdir Backup/"+String(folder))
  if(!system("idevicebackup2 backup Backup/"+String(folder)))
    exit(1)
  else
    system("idevicebackup2 unback Backup/"+String(folder))
  end
end

pseudo_skype = ""
path = "Backup/"+String(folder)
command = ""

puts "Interresting Data !\n"

while command != "quit"
  print "> "
  command = gets.chomp

  if command == "help"
    puts "LIST OF COMMANDS :"
    puts "-- OS --"
    puts "help         => Show all commands"
    puts "quit         => Leave the software"
    puts "calls        => Show all calls"
    puts "accounts     => Show all accounts"
    puts "addressbook  => Show the address book"
    puts "pictures     => Show all pictures"
    puts "md_mails     => Show metadatas of mails"
    puts "sms          => Show all sms"
    puts "notes        => Show all notes"
    puts "recordings   => Show all recordings"
    puts ""
    puts "-- SHAZAM --"
    puts "shazam artists => Show artists who was tagged"
    puts ""
  elsif command == "quit"
    puts "Good Bye !"
  elsif command == "all"
    puts "\nCALLS"
    all_calls(path)
    puts "\nACCOUNTS"
    all_accounts(path)
    puts "\nADDRESS BOOK"
    all_address_book(path)
    puts "\nMETA-DATA'S MAILS"
    all_md_mails(path)
    puts "\nSMS"
    all_sms(path)
  elsif command == "calls"
    all_calls(path)
  elsif command == "accounts"
    all_accounts(path)
  elsif command == "addressbook"
    all_address_book(path)
  elsif command == "pictures"
    all_pictures(path)
  elsif command == "md_mails"
    all_md_mails(path)
  elsif command == "sms"
    all_sms(path)
  elsif command == "notes"
    all_notes(path)
  elsif command == "recordings"
    all_recordings(path)
  elsif command == "safari bookmarks"
    all_safari_bookmarks(path)
  elsif command == "safari history"
    all_safari_history(path)
  elsif command == "skype calls"
    skype_calls(path)
  elsif command == "skype messages"
    skype_messages(path)
  elsif command == "skype contacts"
    skype_contacts(path)
  elsif command == "shazam artists"
    shazam_artists(path)
  else
    puts "Command not found !"
  end
end
