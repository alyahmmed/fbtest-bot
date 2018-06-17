class AddSessionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :session, :text
  end
end
