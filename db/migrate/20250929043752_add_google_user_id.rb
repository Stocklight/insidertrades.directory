class AddGoogleUserId < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :google_user_id, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :photo_url, :string
  end
end
