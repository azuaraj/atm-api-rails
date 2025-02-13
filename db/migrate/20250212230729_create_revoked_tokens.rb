class CreateRevokedTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :revoked_tokens do |t|
      t.string :jti

      t.timestamps
    end
    add_index :revoked_tokens, :jti
  end
end
