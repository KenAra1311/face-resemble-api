class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :uid
      t.boolean :admin
      t.string :profile_image
      t.string :file_name

      t.timestamps
    end
  end
end
