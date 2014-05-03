class CreateTwiModels < ActiveRecord::Migration
  def change
    create_table :twi_models do |t|
      t.string :uid
      t.string :tweetid
      t.string :time
      t.string :re_uid
      t.string :image
      t.text :text

      t.timestamps
    end
  end
end
