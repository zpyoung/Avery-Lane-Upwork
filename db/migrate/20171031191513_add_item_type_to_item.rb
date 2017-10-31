class AddItemTypeToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :item_type, :string
  end
end
