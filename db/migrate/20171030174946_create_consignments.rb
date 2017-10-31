class CreateConsignments < ActiveRecord::Migration[5.0]
  def change
    create_table :consignments do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.datetime :date_available
      t.boolean :need_pickup
      t.timestamps
    end

    create_table :items do |t|
      t.references :consignment
      t.string :image
      t.text :description
      t.string :type
      t.timestamps
    end
  end
end
