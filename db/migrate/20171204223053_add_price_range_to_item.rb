class AddPriceRangeToItem < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :price_range, :string
  end
end
