class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :fbid, :limit => 8
    	t.string :fname, default: ''
    	t.string :lname, default: ''
    	t.string :gender, default: ''
    	t.string :fbimg, default: ''
    	t.string :lang, default: 'en'
      t.boolean :status, default: true
      t.datetime :login_at, null: true
      t.timestamps
    end
  end
end
