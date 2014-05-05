class Addcolumns < ActiveRecord::Migration
  def change
    add_column :twi_models,:ret_nickname,:string
  

  end
end
