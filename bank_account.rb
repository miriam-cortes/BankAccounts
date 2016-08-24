# Create a Bank module which will contain your Account class and any future bank account logic.
# Create an Account class which should have the following functionality:
 # A new account should be created with an ID and an initial balance
 # Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
 # Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
 # Should be able to access the current balance of an account at any time.
## Error handling ##
  # A new account cannot be created with initial negative balance - this will raise an ArgumentError
  # The withdraw method does not allow the account to go negative - Will output a warning message and return the original un-modified balance

## Optional: ##
  # Create an Owner class which will store information about those who own the Accounts.
    # should have info like name and address and any other identifying information that an account owner would have.
  # Add an owner property to each Account to track information about who owns the account.
  # The Account can be created with an owner, OR you can create a method that will add the owner after the Account has already been created.



module Bank
  class Account
    attr_accessor :initial_balance, :deposit_amount, :withdraw_amount
    def initialize(initial_balance)
      @id = Random.rand(100000..999999)
      @account_owner
      if initial_balance <= 0
        raise ArgumentError.new("You can't open an account with $0 or less.")
      else
        @balance = initial_balance
      end
      puts "Thanks for opening an account with Mr. T!"
      puts "Account number: #{@id}"
      show_current_balance
      puts "Thanks for giving me your money, Fool!"
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
      puts "Balance: $#{sprintf "%.2f", @balance}"
    end
  end

end


puts "..........Opening a new account with $1.57 balance results in.........."
account1 = Bank::Account.new(1.57)
puts "..........a deposit of $3.........."
account1.deposit(3)
puts "..........Trying to withdraw $8.........."
account1.withdraw(8)
puts "..........Showing current balance.........."
account1.show_current_balance
puts "..........Depositing a negative.........."
account1.deposit(-3)
puts "..........Trying to withdraw $0.........."
account1.withdraw(0)
puts "..........Opening a new account with $0 balance results in.........."
account200 = Bank::Account.new(0)
