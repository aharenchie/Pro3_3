class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :userid
      t.string :tweetid

      t.timestamps
    end
  end
end
