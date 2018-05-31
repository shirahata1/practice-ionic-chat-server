class AddNotificationTokenColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_token, :string
  end
end
