class AddAdminCreatedToConsignment < ActiveRecord::Migration[5.0]
  def change
    add_column :consignments, :admin_created, :boolean, default: false
  end
end
