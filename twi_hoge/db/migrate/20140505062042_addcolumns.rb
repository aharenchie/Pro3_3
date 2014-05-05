class Addcolumns < ActiveRecord::Migration
  def change
  end

  def up
    add_column :twi_models,:re_nickname,:string
    add_column :models,:hogename,:string
  end

end
