#######
# CALLS
def skype_calls(path, pseudo, export)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/#{pseudo}/main.db"
    db.results_as_hash = true
    stm = db.execute "SELECT identity, dispname, languages, call_duration  FROM CallMembers"
    if(export == 1)
      Prawn::Document.generate("Exports/Skype/Calls.pdf") do |pdf|
        pdf.text "Skype Calls\n\n\n", :size => 25
        rows = [["Pseudo", "Name", "Languages", "Call duration"]]
        stm.each do |row|
          rows << ["#{row['identity']}","#{row['dispname']}", "#{row['languages']}", (row['call_duration'].to_i/60).to_s+" m"]
        end
        pdf.table(rows)
        pdf.text ""
      end
      puts "\e[32m[+] Skype calls export done\e[0m"
    else
      rows = []
      stm.each do |row|
        rows << ["#{row['identity']}", "#{row['dispname']}", "#{row['languages']}", "#{row['call_duration']}"]
      end
      table_skype_calls = Terminal::Table.new :headings => ['Pseudo', 'Name', 'Languages', 'Call Duration'], :rows => rows
      puts table_skype_calls
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to Skype database.\e[0m"
  ensure
    db.close if db
  end
end

##########
# MESSAGES
def skype_messages(path, pseudo, export)
  line = ""
  begin
  	db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/#{pseudo}/main.db"
    db.results_as_hash = true
    stm = db.execute "SELECT author, from_dispname, body_xml, timestamp FROM Messages"
    if(export == 1)
      Prawn::Document.generate("Exports/Skype/Messages.pdf", :page_layout => :landscape) do |pdf|
        pdf.text "Skype Messages\n\n\n", :size => 25
        rows = [["Author", "Fullname", "Date", "Body"]]
        stm.each do |row|
          rows << ["#{row['author']}","#{row['from_dispname']}", Time.at(row['timestamp'].to_i).to_s, "#{row['body_xml']}"]
        end
        pdf.table(rows)
        pdf.text ""
      end
        puts "\e[32m[+] Skype messages export done\e[0m"
    else
      print "Do you want export results on PDF (recommended) : y/n : "
      pdf = $stdin.gets.chomp
      unless(pdf == "n" or pdf == "y")
        puts "Answer y or n"
        return
      end

      if(pdf == "y")
        Prawn::Document.generate("Skype_messages.pdf") do |pdf|
          pdf.text "Skype Messages\n\n\n", :size => 25
          rows = [["Author", "Fullname", "Date", "Body"]]
          stm.each do |row|
            rows << ["#{row['author']}","#{row['from_dispname']}", Time.at(row['timestamp'].to_i).to_s, "#{row['body_xml']}"]
          end
          pdf.table(rows)
          pdf.text ""
        end
      else
        stm.each do |row|  
          puts "#{row['author']} (#{row['from_dispname']}) ["+Time.at(row['timestamp'].to_i).to_s+"] ==> #{row['body_xml']}\n\n"
        end
      end
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to Skype database.\e[0m"
  ensure
    db.close if db
  end
end


##########
# CONTACTS
def skype_contacts(path, pseudo, export)
  begin
    db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/#{pseudo}/main.db"
    db.results_as_hash = true
    stm = db.execute "SELECT skypename, fullname, country, province, city, emails, about FROM Contacts"
    if(export == 1)
      Prawn::Document.generate("Exports/Skype/Contacts.pdf", :page_layout => :landscape) do |pdf|
        pdf.text "Skype Contacts\n\n\n", :size => 25
        rows = [["Skype pseudo", "Fullname", "Country", "Province", "City", "Email", "About"]]
        stm.each do |row|
          rows << ["#{row['skypename']}","#{row['fullname']}", "#{row['country']}", "#{row['province']}", "#{row['city']}", "#{row['emails']}", "#{row['about']}"]
        end
        pdf.table(rows)
        pdf.text ""
      end
        puts "\e[32m[+] Skype contacts export done\e[0m"
    else
      print "Do you want export results on PDF (recommended) : y/n : "
      pdf = $stdin.gets.chomp
      unless(pdf == "n" or pdf == "y")
        puts "Answer y or n"
        return
      end
    

      if(pdf == "y")
        Prawn::Document.generate("Skype_contact.pdf") do |pdf|
          pdf.text "Skype Contacts\n\n\n", :size => 25
          stm.each do |row|
            rows << ["#{row['skypename']}", "#{row['fullname']}", "#{row['country']}", "#{row['province']}", "#{row['city']}", "#{row['emails']}", "#{row['about']}"]
            pdf.text "#{row['skypename']}\n\n", :size=>20          
            pdf.table([
              ["Skype name", "#{row['skypename']}"],
              ["Fullname", "#{row['fullname']}"],
              ["Country", "#{row['country']}"],
              ["Province", "#{row['province']}"],
              ["City", "#{row['city']}"],
              ["Email", "#{row['emails']}"],
              ["About", "#{row['about']}"]], :width=>500)
            pdf.text "\n\n"
          end
        end
      else
        stm.each do |row|
          rows << ["#{row['skypename']}", "#{row['fullname']}", "#{row['country']}", "#{row['province']}", "#{row['city']}", "#{row['emails']}", "#{row['about']}"]
        end
        table_skype_contacts = Terminal::Table.new :headings => ['Skype name', 'Name', 'Country', 'Province', 'City', 'Emails', 'About'], :rows => rows
        puts table_skype_contacts
      end
    end
  rescue SQLite3::Exception => e
    #puts "Exception occured"
    #puts e
    puts "\e[31m[-] Can't access to Skype database.\e[0m"
  ensure
    db.close if db
  end
end
