# coding: UTF-8
###########
# ALL CALLS
def all_calls(path, export)
  # Phone numbers
  begin
    db = SQLite3::Database.new path+"wireless/Library/CallHistory/call_history.db"
    db.results_as_hash = true
    stm = db.execute "SELECT address, date FROM call"


    # EXPORT ?
    if(export == 1)
      Prawn::Document.generate("Exports/Basics/Calls.pdf") do |pdf|
        pdf.text "Calls\n\n\n", :size => 25
        rows = [["To", "Date"]]
        stm.each do |row|
          rows << ["#{row['address']}", Time.at(row['date'].to_i).to_s]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] Calls export done\e[0m"
    else
      rows = []
      stm.each do |row|
        rows << ["#{row['address']}", Time.at(row['date'])]
      end
      table_calls = Terminal::Table.new :headings => ["To", "Date"], :rows => rows
      puts table_calls
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to calls database.\e[0m"
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
def all_accounts(path, export)
  begin
    db = SQLite3::Database.new path+"mobile/Library/Accounts/Accounts3.sqlite"
    stm = db.execute "SELECT ZACCOUNTDESCRIPTION, ZUSERNAME FROM ZACCOUNT"
    

    # EXPORT ?
    if(export == 1)
      Prawn::Document.generate("Exports/Basics/Accounts.pdf") do |pdf|
        pdf.text "Acounts\n\n\n", :size => 25
        rows = [["Description", "User"]]
        stm.each do |row|
          rows << [row[0], row[1]]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] Accounts export done\e[0m"
    else
      table = Terminal::Table.new :headings => ['Description', 'User'], :rows => stm
      puts table
    end

  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to accounts database.\e[0m"
  ensure
    db.close if db
  end
end

#############
# ADRESS BOOK
def all_address_book(path, export)
  begin
    db = SQLite3::Database.new path+"mobile/Library/AddressBook/AddressBook.sqlitedb"
    stm = db.execute "SELECT ABPerson.First, ABPerson.Last, ABMultiValue.value, ABPerson.Organization, ABPerson.Department, ABPerson.Birthday, ABPerson.JobTitle FROM ABPerson, ABMultiValue WHERE ABPerson.ROWID = ABMultiValue.record_id"
    
    # EXPORT ?
    if(export == 1)
      Prawn::Document.generate("Exports/Basics/Address_book.pdf", :page_layout => :landscape) do |pdf|
        pdf.text "Adress book\n\n\n", :size => 25
        rows = [["First name", "Last name", "Contact", "Organization", "Department", "Birthday", "Job"]]
        stm.each do |row|
          rows << ["#{row[0]}", "#{row[1]}", "#{row[2]}", "#{row[3]}", "#{row[4]}", "#{row[5]}", "#{row[6]}"]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] Address book export done\e[0m"
    else
      table_address_book = Terminal::Table.new :headings => ['First', 'Last', 'Contact', 'Organization', 'Department', 'Birthday', 'JobTitle'], :rows => stm
      puts table_address_book
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to adress book database.\e[0m"
  ensure
    db.close if db
  end
end




##########
# PICTURES
def all_pictures(path, export)
  if export == 1
    system("cp -R "+path+"mobile/Media/DCIM/100APPLE/ Exports/Pictures/")
  else
    system("open "+path+"mobile/Meida/DCIM/100APPLE/ &")
  end
end


#############
# META DATA MAILS
def all_md_mails(path, export)
  begin
    db = SQLite3::Database.new path+"mobile/Library/Mail/Recents"
    db.results_as_hash = true
    stm = db.execute "SELECT display_name, address, sending_address, last_date FROM recents"
    
    # EXPORT ?
    if(export == 1)
      Prawn::Document.generate("Exports/Basics/Metadata_Mails.pdf") do |pdf|
        pdf.text "Mails metadata\n\n\n", :size => 25
        rows = [["Receiver", "Receiver address", "Date"]]
        stm.each do |row|
          rows << [row[0], row[1], Time.at(row['last_date']).to_s]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] Mails metadata export done\e[0m"
    else
      rows = []
      stm.each do |row|
        rows << ["#{row['display_name']}", "#{row['address']}", "#{row['sending_address']}", Time.at(row['last_date'])]
      end
      table_md_mails = Terminal::Table.new :headings => ['Receiver', 'Address of Receiver', 'Address of sender', 'Date'], :rows => rows
      puts table_md_mails
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to mails metadata database.\e[0m"
  ensure
    db.close if db
  end
end


######
# SMS
def all_sms(path, export)
  begin
    db = SQLite3::Database.new path+"mobile/Library/SMS/sms.db"
    db.results_as_hash = true
    stm = db.execute "SELECT text, service, account, date FROM message"
    # EXPORT ?
    if(export == 1)
      Prawn::Document.generate("Exports/Basics/SMS.pdf") do |pdf|
        pdf.text "SMS\n\n\n", :size => 25
        rows = [["Account", "Service", "Text", "Date"]]
        stm.each do |row|
          rows << [row[0], row[1], row[2], Time.at(row['date']).to_s]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] SMS export done\e[0m"
    else
      rows = []
      stm.each do |row|
        rows << ["#{row['account']}", "#{row['service']}", "#{row['text']}", Time.at(row['date'])]
      end
      table_sms = Terminal::Table.new :headings => ['Account', 'Service', 'Text', 'Date'], :rows => rows
      puts table_sms
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to SMS database.\e[0m"
  ensure
    db.close if db
  end
end




#######
# NOTES
def all_notes(path, export)
  begin
    db = SQLite3::Database.new path+"mobile/Library/Notes/notes.sqlite"
    db.results_as_hash = true
    stm = db.execute "SELECT ZCONTENT FROM ZNOTEBODY"
    # EXPORT ?
    if(export == 1)
      file = File.open('Exports/Basics/Notes.html', 'w')
      file.puts('<!DOCTYPE html>
        <html>
        <head>
        <meta charset="UTF-8" />
        </head>
        <body>
        <h1>Notes</h1>')
      stm.each do |row|
        file.puts(row[0])
        file.puts("<br />----------------------------------------------------<br />")
      end
      file.puts("</body></html>")
      file.close
      puts "\e[32m[+] Notes export done\e[0m"
    else
      stm.each do |row|
        puts "\n\n\n"
        puts row
      end
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to notes database.\e[0m"
  ensure
    db.close if db
  end
end


###########
# RECORDING
def all_recordings(path, export)
  if export == 1
    system("cp "+path+"mobile/Media/Recordings/*.m4a Exports/Recordings/")
  else
    system("open "+path+"mobile/Media/Recordings/")
  end
end

####################
# SAFARI - BOOKMARKS
def all_safari_bookmarks(path, export)
  begin
    db = SQLite3::Database.new path+"mobile/Library/Safari/Bookmarks.db"
    stm = db.execute "SELECT title, url FROM bookmarks"
    # EXPORT ?
    if(export == 1)
      Prawn::Document.generate("Exports/Basics/Safari/Bookmarks.pdf") do |pdf|
        pdf.text "Bookmarks\n\n\n", :size => 25
        rows = [["Title", "URL"]]
        stm.each do |row|
          rows << [row[0], row[1]]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] Safari bookmarks export done\e[0m"
    else
      table_safari_bookmarks = Terminal::Table.new :headings => ['Title', 'URL'], :rows => stm
      puts table_safari_bookmarks
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to Safari bookmarks database.\e[0m"
  ensure
    db.close if db
  end
end

##################
# SAFARI - HISTORY
def all_safari_history(path, export)
  begin
    plist = CFPropertyList::List.new(:file => path+"mobile/Library/Safari/SuspendState.plist")
    data = CFPropertyList.native_types(plist.value)
    # EXPORT ?
    if(export == 1)
      file = File.open('Exports/Basics/Safari/History.html', 'w')
      file.puts('<!DOCTYPE html>
        <html>
        <head>
        <meta charset="UTF-8" />
        </head>
        <body>
        <h1>Safari History</h1>')

      for item in data["SafariStateDocuments"]
        if item != ""
          file.puts "<br />
          <br />"
          for item_back in item["SafariStateDocumentBackForwardList"]["entries"]
            file.puts "<a href='"+item_back[""]+"'>"+item_back['title']+"</a><br />"
          end
          file.puts "<a href='"+item["SafariStateDocumentURL"]+"'>"+item["SafariStateDocumentTitle"]+"</a><br />"

        end
      end


      file.puts("</body></html>")
      file.close
      puts "\e[32m[+] Safari history export done\e[0m"
    else
      for item in data["SafariStateDocuments"]
        if item != ""
          for item_back in item["SafariStateDocumentBackForwardList"]["entries"]
            puts item_back['title']+"\n"
          end
          puts item["SafariStateDocumentTitle"]+"\n\n"
        end
      end
    end
  rescue
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to Safari history database.\e[0m"
  end
end