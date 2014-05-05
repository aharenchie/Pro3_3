class Addindex < ActiveRecord::Migration
  def change

  
    add_index :twi_models,:uid
    add_index :twi_models,:tweetid
  end



end
