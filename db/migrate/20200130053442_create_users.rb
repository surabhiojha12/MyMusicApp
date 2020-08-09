class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :phone_no
      t.boolean :type_of_user #consumer or provider
      t.string :password_digest
      t.timestamps null: false
    end
  end
end
