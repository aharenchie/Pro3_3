class Addcolumns < ActiveRecord::Migration
  def change
    add_column :twi_models,:ret_nickname,:string
    add_column :twi_models,:rt_id,:string
  

  end
end
