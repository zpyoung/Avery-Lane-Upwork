class AddFieldsToConsignment < ActiveRecord::Migration[5.0]
  def change
    add_column :consignments, :address_1_pickup, :string
    add_column :consignments, :address_2_pickup, :string
    add_column :consignments, :city_pickup, :string
    add_column :consignments, :state_pickup, :string
    add_column :consignments, :zip_pickup, :string
    add_column :consignments, :address_1_mailing, :string
    add_column :consignments, :address_2_mailing, :string
    add_column :consignments, :city_mailing, :string
    add_column :consignments, :state_mailing, :string
    add_column :consignments, :zip_mailing, :string
    add_column :consignments, :home_phone, :string
    add_column :consignments, :consigner_number, :string
    add_column :consignments, :consignment_price, :decimal
    add_column :consignments, :contract, :text
    add_column :consignments, :contract_additional_item, :text
    add_column :consignments, :status, :integer, default: 0


    add_column :items, :item_status, :integer, default: 0
    add_column :items, :item_price, :decimal
    add_column :items, :item_number, :string
  end
end
