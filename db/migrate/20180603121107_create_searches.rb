class CreateSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :searches do |t|
    	t.integer :fbid
    	t.string :keyword, default: ''
    	t.string :bookid, default: ''
      t.timestamps
      t.timestamps
    end
  end
end
