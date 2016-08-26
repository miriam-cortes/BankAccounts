require 'csv'
require 'awesome_print'
# Wave 1
# Bank module; contains Account class and any future bank account logic.
module Bank
  # Account class- parent of savings and checking accounts
  class Account
    attr_accessor :balance, :deposit_amount, :withdraw_amount, :accountnumber, :account_open_date
    @@account_hash = {}
    # New accounts created with an ID and an initial balance
    def initialize(balance,account_open_date = Time.now)
      @id = Random.rand(100000..999999)
      @balance
      @account_open_date = account_open_date
      @minimum_balance = 0
      @withdraw_fee = 0
      check_opening_balance(balance)
      show_current_balance
      return @balance
    end

    # new accounts cannot be created with initial balance < minimum balance... raises an ArgumentError
    def check_opening_balance(balance)
      if balance <= @minimum_balance
        raise ArgumentError.new("You can't open an account with $#{@minimum_balance} or less.")
      else
        @balance = balance
        return @balance
      end
    end

    # WAVE 2 #
    # Updated Account class to be able to handle all fields from CSV file used as input
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

    # returns a collection of Account instances, representing all Accounts described in the CSV
    def self.all
      @@account_hash.each do |key,value|
        puts "#{key} has balance $#{value.balance} & opened #{value.account_open_date[0..9]}"
      end
      return @@account_hash
    end

    # returns an instance of Account where value of the id field in the CSV matches the passed parameter
    def self.find(id)
      return @@account_hash[id.to_s]
    end

    # deposit method accepts a single parameter: amount deposited
    # method calls show_current_balance method, which returns updated account balance
    def deposit(deposit_amount)
      if deposit_amount <= 0
        puts "dummy."
      else
        @balance += deposit_amount
      end
      show_current_balance
    end

    # withdraw method accepts a single parameter: money withdrawn
    # method calls show_current_balance method, which returns updated account balance
    def withdraw(withdraw_amount)
      transaction = withdraw_amount + @withdraw_fee
      if withdraw_amount <= 0
        puts "dummy."
      elsif @minimum_balance == (@balance - transaction)
      # withdraw method does not allow account to be < minimum balance - Will output a warning message and return the original un-modified balance
        puts "Warning: balance will be the minimum balance. I won't do that out of principle."
      elsif @minimum_balance > (@balance - transaction)
      # same thing here as above- balance cannot be less than minimum
        puts "You trying to steal from me?? This is your warning!"
      else
        @balance -= (transaction)
      end
      show_current_balance
    end

    # returns the account balance
    def show_current_balance
      return "Balance: $#{sprintf "%.2f", @balance}"
    end
  end

  # Wave 3
  # SavingsAccount class inherits behavior from the Account class
  class SavingsAccount < Account
    def initialize(balance,account_open_date = Time.now)
      super
      @withdraw_fee = 2
      @minimum_balance = 10
      # The initial balance cannot be less than $10. If it is, this will raise an ArgumentError
      check_opening_balance(balance)
      @interest
    end

    def add_interest(rate) #Calculates the interest & adds the interest to the balance. Returns the interest calculated and added to the balance (not the updated balance)
      @interest = @balance * rate/100
      @balance += @interest
      return @interest
    end
  end

  # CheckingAccount class inherits behavior from the Account class
  # uses withdraw method from parent
  class CheckingAccount < Account
    attr_reader :checks_used
    def initialize(balance,account_open_date = Time.now)
      super
      @withdraw_fee = 1 # withdrawals incur fee ($1) taken out of the balance
      @minimum_balance = 0
      @overdraft = -10 #only for checks
      @checks_used = 0 # user is allowed 3 free checks in a month; any subsequent use adds $2 fee

    end

    # Method is different than just withdrawing because it allows for an overdraft of $10, but still calls to the withdraw method
    def withdraw_using_check(amount)
      @minimum_balance = -10
      if (@balance - amount - @withdraw_fee) >= @minimum_balance
        @checks_used += 1

        # user is allowed 3 free checks in a month; any subsequent use adds $2 fee
        if @checks_used < 4
          @withdraw_fee = 0
        else
          @withdraw_fee = 1
        end

        withdraw(amount)
        @minimum_balance = 0 #reset the minimum_balance
      else
        puts "Sorry, that's beyond the overdraft allowance."
        @minimum_balance = 0
      end
      show_current_balance
    end

    # resets number of checks used to 0 (at end of the month)
    def reset_checks
      @checks_used = 0
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

puts "\n\n## WAVE 3 ##"
puts "...Opening a new savings account with $104 balance results in..."
savings1 = Bank::SavingsAccount.new(104)
puts "Balance: #{savings1.balance}"
puts "...Trying to withdraw $2 from savings (withdrawal fee is $2)..."
puts savings1.withdraw(2)
puts "...Adding interest..."
puts "Interest: #{savings1.add_interest(0.25)}%"
puts "...New Balance (after interest)..."
puts savings1.show_current_balance
puts "\n...Opening a new checking account with $100 balance results in..."
checking1 = Bank::CheckingAccount.new(100)
puts "Balance: #{checking1.balance}"
puts "...Withdrawing $2 from checking (fee is $1)..."
puts checking1.withdraw(2)
checking1.reset_checks
puts "...Writing checks for $2 (overdrafting allowed to $10; no fees until 4th check then $1)..."
checking1.withdraw_using_check(2)
puts checking1.show_current_balance
checking1.withdraw_using_check(2)
puts checking1.show_current_balance
checking1.withdraw_using_check(2)
puts checking1.show_current_balance
checking1.withdraw_using_check(2)
puts checking1.show_current_balance
checking1.withdraw_using_check(97)
puts checking1.show_current_balance
puts "New month!"
checking1.reset_checks
checking1.withdraw_using_check(10)
puts checking1.show_current_balance

puts "\n\n## WAVE 1 ##"
puts "...Opening a new account with $1.57 balance results in..."
account1 = Bank::Account.new(1.57)
ap account1
puts "...a deposit of $3..."
puts account1.deposit(3)
puts "...Trying to withdraw $8..."
puts account1.withdraw(8)
puts "...Showing current balance..."
puts account1.show_current_balance
puts "...Depositing a negative..."
puts account1.deposit(-3)
puts "...Trying to withdraw $0..."
puts account1.withdraw(0)
puts "...Opening a new account with $0 balance results in..."
puts "an argument error that I've commented out so the rest of the program will run."
# account1= Bank::Account.new(0)

puts "\n\n## WAVE 2 ##"
puts "...Reading the csv file and putting it into a hash..."
users = Bank::Account.reading_accounts
# ap users
puts "...Printing out all the accounts' information..."
all_users = Bank::Account.all
# ap all_users
puts "...Printing out one accounts' information..."
one_new_user = Bank::Account.find(15153)
ap one_new_user

puts "\n\n## WAVE 1 OPTIONALS ##"
user2_info = Bank::Owner.new(name:"name",city:"city",state:"state",zip:"zip")
puts "User 2's info...\nname:#{user2_info.name} \naddress: #{user2_info.city}, #{user2_info.state} #{user2_info.zip}\n"
user2_account = Bank::Account.new(5.67)
connected_personal_and_account_info = user2_info.add_account_info_to_owner(user2_account)
puts connected_personal_and_account_info
