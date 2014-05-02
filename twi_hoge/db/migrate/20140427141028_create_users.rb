class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :screen_name
      t.string :name

      t.string :token
      t.string :token_secret

      t.timestamps
    end
  end
end
