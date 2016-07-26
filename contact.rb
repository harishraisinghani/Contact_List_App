require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email)
    @name = name
    @email = email
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      CSV.read('contacts.csv')
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      contact = Contact.new(name,email)
      CSV.open('contacts.csv', 'a') do |row|
        row << [name,email]
      end
      contact
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      arr = Contact.all
      arr.at(id.to_i-1)
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      arr = Contact.all
      filter_arr = []
      arr.each do |row|
        if (row[0].include?(term.to_s) || row[1].include?(term.to_s))
          filter_arr << "#{arr.index(row)+1}: #{row[0]} (#{row[1]})"
        end          
      end
      filter_arr
    end

  end

end
