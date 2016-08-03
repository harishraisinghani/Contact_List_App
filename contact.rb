require 'csv'
require 'pg'


# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  @@connection = nil
  def self.connection
    @@connection = @@connection || PG.connect(host: 'localhost', dbname: 'contacts', user: 'development', password: 'development')
  end

  attr_reader :id

  attr_accessor :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email, id=nil)
    @name = name
    @email = email
    @id = id
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      #CSV.read('contacts.csv') - old method
      Contact.connection.exec('SELECT * FROM contacts ORDER BY id;')
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      contact = Contact.new(name,email)
      contact.save
      
      #contact = Contact.new(name,email)
      #CSV.open('contacts.csv', 'a') do |row|
      #  row << [name,email]
      #end
      #contact
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      begin
        res = Contact.connection.exec_params('SELECT * FROM contacts WHERE id = $1::int;', [id])[0]
      rescue
        return nil
      end
      Contact.new(res["name"], res["email"],res["id"])
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      result = Contact.connection.exec_params("SELECT * FROM contacts WHERE (name LIKE $1) OR (email LIKE $1);", ["%#{term}%"])
    end
  end

  def save
    if id.nil?
      self.class.connection.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2);' , [name, email])
    else
      self.class.connection.exec_params('UPDATE contacts SET name=$1, email=$2 WHERE id=$3::int;', [name, email, id])
    end
  end

  def destroy
    Contact.connection.exec_params('DELETE FROM contacts WHERE id = $1::int;', [id])
  end
end
