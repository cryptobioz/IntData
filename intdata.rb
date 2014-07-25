#!/usr/bin/ruby

require 'sqlite3'
require 'terminal-table'
require 'plist'
require 'prawn'
require 'prawn/table'
load 'plugins/shazam.rb'
load 'plugins/skype.rb'
load 'plugins/mumble.rb'
load 'plugins/mango.rb'


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






################################
#
##################################

#######
#



########
# MAIN #
########


# Check gems installed

begin
  gem "prawn"
  gem "sqlite3"
  gem "terminal-table"
  gem "plist"
rescue Gem::LoadError
  puts "You have to install gem Prawn, Sqlite3, terminal-table, Plist."
  exit(1)
end



# Variables

# Check Backup folder
if(system("ls Backup/ > /dev/null") == false)
  system("mkdir Backup")
  puts "Directory 'Backup' is create"
end



if(ARGV[0] == "-h")
  puts "ruby intdata.rb DIRECTORY         => Use backup directory"
  puts "ruby intdata.rb backup DIRECTORY  => Create a backup from your iDevice and use it"
  exit(1)
# Using libimobiledevice for create a backup of the device
# If user choose "backup"
elsif(ARGV[0] == "backup")
  if(ARGV[1])
    folder = ARGV[1]
  else
    puts "You have to specify the destination folder with -f FOLDER"
    exit(1)
  end
  # Folder creation
  system("mkdir Backup/#{folder}")
  if(!system("idevicebackup2 backup Backup/#{folder}"))
    exit(1)
  else
    system("idevicebackup2 unback Backup/#{folder}")
  end
# If user want search into backup
else
  if(ARGV[0])
    folder = ARGV[0]

  # Check if destination folder is available
  if(system("ls #{folder} > /dev/null") == false)
	puts "Directory doesn't exist ! You have to do a backup of your device with : ruby intdata.rb backup DESTINATION_FOLDER"
	exit(1)
  end
  else
    puts "You have to specify the destination folder"
    exit(1)
  end
end

pseudo_skype = ""
unback_folder = `ls #{folder}/_unback_/`.chomp
path = "#{folder}/_unback_/#{unback_folder}/var/"
command = ""

puts "Interresting Data !\n"

while command != "quit"
  print "> "
  command = $stdin.gets.chomp

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
    puts "-- SKYPE --"
    puts "skype calls    => Show Skype calls"
    puts "skype messages => Show Skype messages"
    puts "skype contacts => Show Skype contacts"
    puts ""
    puts "-- MUMBLE --"
    puts "mumble favorites => Show Mumble favorites"
    puts ""
    puts "-- MANGO --"
    puts "mango servers => Show your user's settings for each servers"
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
  # SKYPE
  elsif command == "skype calls"
    if pseudo_skype == ""
      print "Enter a skype pseudo : "
      pseudo_skype = $stdin.gets.chomp
    end
    skype_calls(path, pseudo_skype)

  elsif command == "skype messages"
    if pseudo_skype == ""
      print "Enter a skype pseudo : "
      pseudo_skype = $stdin.gets.chomp
    end
    skype_messages(path, pseudo_skype)

  elsif command == "skype contacts"
    if pseudo_skype == ""
      print "Enter a skype pseudo : "
      pseudo_skype = $stdin.gets.chomp
    end
    skype_contacts(path, pseudo_skype)
    # MUMBLE
  elsif command == "mumble favorites"
    mumble_favorites(path)


  # SHAZAM
  elsif command == "shazam artists"
    shazam_artists(path)

  # MANGOLITE
  elsif command == "mango servers"
  	mango_servers(path)
  else
    puts "Command not found !"
  end
end
