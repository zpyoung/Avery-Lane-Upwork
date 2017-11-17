class AddDashboardModifiedToConsignment < ActiveRecord::Migration[5.0]
  def change
    add_column :consignments, :dashboard_modified, :boolean, default: false
  end
end
