class AddValueToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :value, :decimal
    add_column :items, :price, :decimal
    add_column :items, :cost, :decimal
  end
end
