class Account < ApplicationRecord
  has_secure_password :pin, validations: false

  validates :atm_account_number, presence: true, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def authenticate(pin)
    authenticate_pin(pin)
  end

  def deposit!(amount)
    validate_amount!(amount)

    ActiveRecord::Base.transaction do
      account = Account.lock.find(self.id)
      account.update!(balance: account.balance + amount)
    end

    self.reload.balance
  end

  def withdraw!(amount)
    validate_amount!(amount)

    ActiveRecord::Base.transaction do
      account = Account.lock.find(self.id)
      validate_sufficient_funds!(account, amount)

      account.update!(balance: account.balance - amount)
    end

    self.reload.balance
  end

  private

  def validate_amount!(amount)
    raise ArgumentError, "Amount must be positive" unless amount.positive?
  end

  def validate_sufficient_funds!(account, amount)
    raise StandardError, "Insufficient funds" if account.balance < amount
  end
end
