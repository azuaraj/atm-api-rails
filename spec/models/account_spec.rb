require 'rails_helper'

require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { Account.create!(atm_account_number: "12345678", pin: "1234", balance: 1000.0) }

  describe "#deposit!" do
    it "increases the balance by the deposited amount" do
      expect { account.deposit!(500) }.to change { account.reload.balance }.by(500)
    end

    it "raises an error when depositing a negative amount" do
      expect { account.deposit!(-100) }.to raise_error(ArgumentError, "Amount must be positive")
    end
  end

  describe "#withdraw!" do
    it "decreases the balance by the withdrawn amount" do
      expect { account.withdraw!(300) }.to change { account.reload.balance }.by(-300)
    end

    it "raises an error when withdrawing more than the balance" do
      expect { account.withdraw!(5000) }.to raise_error(StandardError, "Insufficient funds")
    end

    it "raises an error when withdrawing a negative amount" do
      expect { account.withdraw!(-100) }.to raise_error(ArgumentError, "Amount must be positive")
    end
  end

  describe "race condition prevention" do
    it "prevents race conditions in concurrent deposits" do
      threads = []
      10.times { threads << Thread.new { account.deposit!(100) } }
      threads.each(&:join)

      expect(account.reload.balance).to eq(2000.0)
    end

    it "prevents race conditions in concurrent withdrawals" do
      threads = []
      5.times { threads << Thread.new { account.withdraw!(100) } }
      threads.each(&:join)

      expect(account.reload.balance).to eq(500.0)
    end
  end
end
