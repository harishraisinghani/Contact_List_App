require_relative 'contact'
require 'pry-byebug'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  class << self

    def new_entry
      puts "Enter new contact's full name:"
      name = STDIN.gets.chomp
      puts "Enter new contact's full email address:"
      email = STDIN.gets.chomp
      Contact.create(name,email)
      puts "Your contact was succesfully created with ID #{Contact.all.count}"
    end

    def list
      arr = Contact.all
      arr.each do |row|
        puts "#{row["id"]}: #{row["name"]} (#{row["email"]})"
      end
      puts "---\n #{arr.count} record#{'s' unless arr.count == 1} total"
    end

    def valid_id?(id)
      if id == nil
        puts "Please enter an ID number with this command"
        return false
      else
        @the_contact = Contact.find(id)
        
        if @the_contact == nil
          puts "The contact with that ID not found"
          return false
        end
      end
      true
    end

    def show
      id = ARGV[1]
      if valid_id?(id)
        puts "#{@the_contact.id}: #{@the_contact.name} (#{@the_contact.email})" 
      end
    end

    def search
      term = ARGV[1]
      result = Contact.search(term)
      result.each { |row| puts "#{row["id"]}: #{row["name"]} (#{row["email"]})"}
      puts "---\n #{result.count} record#{'s' unless result.count == 1} total"
    end

    def update
      id = ARGV[1]
      if valid_id?(id)
        puts "Enter updated contact's name:"
        new_name = STDIN.gets.chomp
        puts "Enter updated contact's email address:"
        new_email = STDIN.gets.chomp
        @the_contact.name = new_name
        @the_contact.email = new_email
        @the_contact.save
        puts "Contact #{@the_contact.id}: #{@the_contact.name} (#{@the_contact.email}) updated"
      end
    end

    def destroy
      id = ARGV[1]
      if valid_id?(id)
        @the_contact.destroy
        puts "Contact successfully removed"
      end
    end

  end
end

#Takes in the user's input
command = ARGV[0]

#Options for user input
case command
when 'list' then ContactList.list
when 'new' then ContactList.new_entry
when 'show' then ContactList.show
when 'search' then ContactList.search
when 'update' then ContactList.update
when 'destroy' then ContactList.destroy
else puts "Here is a list of available commands:\n\tnew\t-Create a new contact\n\tlist\t-List all contacts\n\tshow\t-Show a contact\n\tsearch\t-Search contacts\n\tupdate\t-Update a contact\n\tdestroy\t-Remove a contact\n"
end
