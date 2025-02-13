class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :atm_account_number
      t.string :pin_digest
      t.decimal :balance

      t.timestamps
    end
  end
end
