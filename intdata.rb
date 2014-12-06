#!/usr/bin/env ruby

"""
A forensic tool for fast research in the memory of your iPhone, iPad or iPod
Copyright (C) 2014  Léo Depriester (leo.depriester@exadot.fr)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

# Check gems installed

begin
  gem "prawn"
  gem "sqlite3"
  gem "terminal-table"
  gem "plist"
rescue Gem::LoadError
  puts "You have to install gem Prawn, Sqlite3, terminal-table, Plist, Colorize."
  exit(1)
end

require 'sqlite3'
require 'terminal-table'
require 'plist'
require 'prawn'
require 'prawn/table'
load 'plugins/shazam.rb'
load 'plugins/skype.rb'
load 'plugins/mumble.rb'
load 'plugins/mango.rb'
load 'plugins/basics.rb'
load 'export_pdf.rb'





########
# MAIN #
########



# Variables

# Check Backup folder
if(system("ls Backup/ > /dev/null") == false)
  system("mkdir Backup")
  puts "[*] Directory 'Backup' was created"
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
    puts "\e[31m[-] You have to specify the destination folder\e[0m"
    exit(1)
  end
  # Folder creation
  system("mkdir #{folder}")
  if(!system("idevicebackup2 backup #{folder}"))
    exit(1)
  else
    system("idevicebackup2 unback #{folder}")
  end
# If user want search into backup
else
  if(ARGV[0])
    folder = ARGV[0]

  # Check if destination folder is available
  if(system("ls #{folder} > /dev/null") == false)
	puts "\e[31m[-] Directory doesn't exist ! You have to do a backup of your device with : ruby intdata.rb backup DESTINATION_FOLDER\e[0m"
	exit(1)
  end
  else
    puts "\e[31m[-] You have to specify the destination folder\e[0m"
    exit(1)
  end
end

pseudo_skype = ""
unback_folder = `ls #{folder}/_unback_/`.chomp
path = "#{folder}/_unback_/#{unback_folder}/var/"
command = ""

puts "\e[0mIntData !\n"

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
    puts "-- Export data --"
    puts "export all => Export all data to PDF files"
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
    all_calls(path, 0)
  elsif command == "accounts"
    all_accounts(path, 0)
  elsif command == "addressbook"
    all_address_book(path, 0)
  elsif command == "pictures"
    all_pictures(path, 0)
  elsif command == "md_mails"
    all_md_mails(path, 0)
  elsif command == "sms"
    all_sms(path, 0)
  elsif command == "notes"
    all_notes(path, 0)
  elsif command == "recordings"
    all_recordings(path, 0)
  elsif command == "safari bookmarks"
    all_safari_bookmarks(path, 0)
  elsif command == "safari history"
    all_safari_history(path, 0)
  # SKYPE
  elsif command == "skype calls"
    if pseudo_skype == ""
      print "Enter a skype pseudo : "
      pseudo_skype = $stdin.gets.chomp
    end
    skype_calls(path, pseudo_skype, 0)

  elsif command == "skype messages"
    if pseudo_skype == ""
      print "Enter a skype pseudo : "
      pseudo_skype = $stdin.gets.chomp
    end
    skype_messages(path, pseudo_skype, 0)

  elsif command == "skype contacts"
    if pseudo_skype == ""
      print "Enter a skype pseudo : "
      pseudo_skype = $stdin.gets.chomp
    end
    skype_contacts(path, pseudo_skype, 0)
    # MUMBLE
  elsif command == "mumble favorites"
    mumble_favorites(path, 0)
  # SHAZAM
  elsif command == "shazam artists"
    shazam_artists(path, 0)

  # MANGOLITE
  elsif command == "mango servers"
  	mango_servers(path, 0)

  elsif command == "export all"
    export_pdf(path, "all")
  else
    puts "Command not found !"
  end
end
