class AddOtherContactToConsignment < ActiveRecord::Migration[5.0]
  def change
    add_column :consignments, :other_contact, :string
  end
end
