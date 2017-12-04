class AddPriceRangeToConsignment < ActiveRecord::Migration[5.0]
  def change
    add_column :consignments, :price_range, :string
    add_column :consignments, :other_phone, :string
    add_column :consignments, :other_email, :string
  end
end
