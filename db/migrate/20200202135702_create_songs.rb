class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :description
      t.string :song_url
      t.integer :year
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
