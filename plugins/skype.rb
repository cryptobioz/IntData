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
def skype_messages(path, pseudo, pdf)
  line = ""
  begin
  	db = SQLite3::Database.new path+"mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/#{pseudo}/main.db"
    db.results_as_hash = true
    stm = db.execute "SELECT author, from_dispname, body_xml, timestamp FROM Messages"

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

  rescue SQLite3::Exception => e
    puts "Exception occured"
    puts e
  ensure
    db.close if db
  end



end
