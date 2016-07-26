require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  class << self

    def new_entry
      puts "Enter new contact's full name:"
      name = STDIN.gets.chomp
      puts "Enter new contact's full email address:"
      email = STDIN.gets.chomp
      Contact.create(name,email)
      puts "Your contact was succesfully created with ID #{Contact.all.length}"
    end

    def list
      arr = Contact.all 
      arr.each do |row|
        puts "#{arr.index(row)+1}: #{row[0]} (#{row[1]})"
      end
      puts "---\n #{arr.length} record#{'s' unless arr.length == 1} total"
    end

    def show
      id = ARGV[1]
      if id == nil
        puts "Please enter an ID number with the show command"
      else
        contact = Contact.find(id)
        if contact == nil
          puts "The contact with that ID not found"
        else
          puts contact
        end
      end
    end

    def search
      term = ARGV[1]
      result = Contact.search(term)
      puts result
      puts "---\n #{result.length} record#{'s' unless result.length == 1} total"
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
else puts "Here is a list of available commands:\n\tnew\t-Create a new contact\n\tlist\t-List all contacts\n\tshow\t-Show a contact\n\tsearch\t-Search contacts\n"
end
