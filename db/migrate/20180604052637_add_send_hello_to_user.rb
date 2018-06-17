class AddSendHelloToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :send_hello, :boolean
  end
end
