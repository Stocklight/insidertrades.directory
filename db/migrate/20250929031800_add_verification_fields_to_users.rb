class AddVerificationFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :verification_code, :string
    add_column :users, :verification_code_generated_at, :datetime
  end
end
