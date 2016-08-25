### WAVE 1 ###
# Create a Bank module which will contain your Account class and any future bank account logic.
# Create an Account class which should have the following functionality:
 # A new account should be created with an ID and an initial balance
 # Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
 # Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
 # Should be able to access the current balance of an account at any time.
## Error handling ##
  # A new account cannot be created with initial negative balance - this will raise an ArgumentError
  # The withdraw method does not allow the account to go negative - Will output a warning message and return the original un-modified balance

### WAVE 2 ###
# Update the Account class to be able to handle all of these fields from the CSV file used as input.
  # For example, manually choose the data from the first line of the CSV file and ensure you can create a new instance of your Account using that data
# Add the following class methods to your existing Account class
  # self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV. See below for the CSV file specifications
  # self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter
# CSV Data File
# Bank::Account
# The data, in order in the CSV, consists of:
  # ID - (Fixnum) a unique identifier for that Account
  # Balance - (Fixnum) the account balance amount, in cents (i.e., 150 would be $1.50)
  # OpenDate - (Datetime) when the account was opened

require 'csv'
require 'awesome_print'

module Bank
  class Account
    attr_accessor :balance, :deposit_amount, :withdraw_amount, :accountnumber, :account_open_date
    @@account_hash = {}
    def initialize(balance,account_open_date = "time.now")
      @id = Random.rand(100000..999999)
      @balance
      @account_open_date = account_open_date

      if balance <= 0
        raise ArgumentError.new("You can't open an account with $0 or less.")
      else
        @balance = balance
      end
      # "Thanks for giving me your money, Fool!"
      # puts "Thanks for opening an account with Mr. T!"
      # puts "Account number: #{@id}"
      show_current_balance
      return @balance
    end

    def self.reading_accounts
      csv = CSV.read("support/accounts.csv")
      csv.each do |account|
        key = account[0]
        balance = account[1].to_f / 100
        account_open_date = account[2]
        @@account_hash[key] = self.new(balance,account_open_date)
      end
      return @@account_hash
    end

    def self.all
      @@account_hash.each do |key,value|
        puts "#{key} has balance $#{value.balance} & opened #{value.account_open_date[0..9]}"
      end
      return @@account_hash
    end

    def self.find(id)
      return @@account_hash[id.to_s]
    end

    def deposit(deposit_amount)
      if deposit_amount <= 0
        puts "dummy."
      else
        @balance += deposit_amount
      end
      show_current_balance
    end

    def withdraw(withdraw_amount)
      if withdraw_amount <= 0
        puts "dummy."
      elsif @balance <= 0 || @balance < withdraw_amount
        puts "You trying to steal from me?? This is your warning!"
      elsif @balance == withdraw_amount
        puts "Warning: balance will be $0. I won't do that out of principle."
      else
        @balance -= withdraw_amount
      end
      show_current_balance
    end

    def show_current_balance
      return "Balance: $#{sprintf "%.2f", @balance}"
    end
  end

  ## WAVE 1 OPTIONAL ##
  class Owner
    attr_accessor :name, :city, :state, :zip

    def initialize(user_details_hash)
      @name = user_details_hash[:name]
      @city = user_details_hash[:city]
      @state = user_details_hash[:state]
      @zip = user_details_hash[:zip]
      @user_account_array = []
    end

    def add_account_info_to_owner(user_account)
      @user_account_array << user_account
      return @user_account_array
    end

  end

end

## WAVE 1 ##
puts "..........Opening a new account with $1.57 balance results in.........."
account1 = Bank::Account.new(1.57)
ap account1
puts "..........a deposit of $3.........."
puts account1.deposit(3)
puts "..........Trying to withdraw $8.........."
puts account1.withdraw(8)
puts "..........Showing current balance.........."
puts account1.show_current_balance
puts "..........Depositing a negative.........."
puts account1.deposit(-3)
puts "..........Trying to withdraw $0.........."
puts account1.withdraw(0)
puts "..........Opening a new account with $0 balance results in.........."
puts "an error that I've commented out so the rest of the program will run." #account200 = Bank::Account.new(0)

## WAVE 2 ##
puts ".........Reading the csv file and putting it into a hash........."
users = Bank::Account.reading_accounts
ap users
puts ".........Printing out all the accounts' information........."
all_users = Bank::Account.all
ap all_users
puts ".........Printing out one accounts' information........."
one_new_user = Bank::Account.find(15153)
ap one_new_user
puts ""

## WAVE 1 OPTIONALS ##
user2_info = Bank::Owner.new(name:"name",city:"city",state:"state",zip:"zip")
puts "User 2's info -\nname:#{user2_info.name} \naddress: #{user2_info.city}, #{user2_info.state} #{user2_info.zip}\n"
user2_account = Bank::Account.new(5.67)
connected_personal_and_account_info = user2_info.add_account_info_to_owner(user2_account)
puts connected_personal_and_account_info
