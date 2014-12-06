def export_pdf(path, type)
	if(type == "all")
		system("mkdir Exports > /dev/null 2>&1")

		# Basics
		system("mkdir Exports/Basics > /dev/null 2>&1")
		all_calls(path, 1)
		all_accounts(path, 1)
		all_address_book(path, 1)
		system("mkdir Exports/Pictures > /dev/null 2>&1")
		all_pictures(path, 1)
		puts "\e[32m[+] Pictures export done\e[0m"
		all_md_mails(path, 1)
		all_sms(path, 1)
		all_notes(path, 1)
		system("mkdir Exports/Recordings > /dev/null 2>&1")
		all_recordings(path, 1)
		puts "\e[32m[+] Recordings export done\e[0m"
		system("mkdir Exports/Basics/Safari/ > /dev/null 2>&1")
		all_safari_bookmarks(path, 1)

		# Skype
		if File.directory?("#{path}mobile/Applications/com.skype.skype")
			system("mkdir Exports/Skype > /dev/null 2>&1")
			pseudo_e = ""
			while pseudo_e != "n"
				print "Do you have a skype pseudo ? [y/n] "
				pseudo_e = $stdin.gets.chomp
				if pseudo_e == "y"
					print "Skype pseudo : "
					pseudo = $stdin.gets.chomp
					if File.directory?("#{path}mobile/Applications/com.skype.skype/Library/Application\ Support/Skype/#{pseudo}")
						pseudo_e = "n"
						skype_calls(path, pseudo, 1)
						skype_messages(path, pseudo, 1)
						skype_contacts(path, pseudo, 1)
					end	
				end
			end
			if pseudo == nil
				puts "\e[31m[-] No valid pseudo\e[0m"
			end
		else
			puts "[*] No Skype application.\e[0m"
		end

		# Shazam
		if File.directory?("#{path}mobile/Applications/com.shazam.Shazam/")
			system("mkdir Exports/Shazam > /dev/null 2>&1")
			shazam_artists(path, 1)
		else
			puts "[*] No Shazam application.\e[0m"
		end

		# Mumble
		if File.directory?("#{path}mobile/Applications/info.mumble.Mumble/")
			system("mkdir Exports/Mumble > /dev/null 2>&1")
			mumble_favorites(path, 1)
		else
			puts "[*] No Mumble application\e[0m"
		end
	end
end